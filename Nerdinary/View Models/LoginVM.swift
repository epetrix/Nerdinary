//
//  LoginVM.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 5/1/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI
import LocalAuthentication

class LoginVM: ObservableObject {
	
	@EnvironmentObject var viewRouter: ViewRouter
	
	@Published var email = ""
	@Published var password = ""
	@Published var presentingRegisterView: Bool = false
	@Published var failedToLogin: Bool = false
	
	func login() {
	
		authenticateDB(usingBiometrics: false) { success in
			if success {
				UserDefaults.standard.set(true, forKey: "UserIsLoggedIn")
				self.viewRouter.currentPage = .main
				return
			}
			else {
				self.failedToLogin = true
			}
		}
	}
	
	func loginWithBiometrics() {
		authenticateBiometrics() { successBio in
			if successBio {
				self.authenticateDB(usingBiometrics: true) { successDB in
					if successDB {
						UserDefaults.standard.set(true, forKey: "UserIsLoggedIn")
						self.viewRouter.currentPage = .main
						return
					}
					else {
						// print error
					}
				}
			} else {
				//self.failedToLogin = true
				//don't need to use our own alert because Apple already provides one
				return
			}
		}
	}
	
	func authenticateBiometrics(_ completion: @escaping (Bool) -> ()) {
		//print("authenticating")
		let context = LAContext()
		var error: NSError?

		// check whether biometric authentication is possible
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			// it's possible, so go ahead and use it
			let reason = "We need to unlock your data."

			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
				// authentication has now completed
				DispatchQueue.main.async {
					if success {
						// authenticated successfully
						completion(true)
					} else {
						// there was a problem
						completion(false)
					}
				}
			}
		} else {
			// no biometrics
		}
	}
	
	func authenticateDB(usingBiometrics: Bool, _ completion: @escaping(Bool) -> Void) {
		let group = DispatchGroup()
		group.enter()
		
		if usingBiometrics {
			let uid = UserDefaults.standard.integer(forKey: "userID")
			if uid == 0 {
				print("Invalid User ID")
				group.leave()
				completion(false)
			}
			
			guard let url = URL(string: "http://127.0.0.1:5000/user/\(uid)") else {
				print("Invalid URL")
				group.leave()
				completion(false)
				return
			}
			
			let request = URLRequest(url: url)
			
			//print(String(data: request.httpBody!, encoding: .utf8)!)
			
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				//result is get
				if let data = data, let dataString = String(data: data, encoding: .utf8), let httpResponse = response as? HTTPURLResponse {
					if httpResponse.statusCode != 200 {
						print("Error code: \(httpResponse.statusCode)")
						print("Response:\n\(dataString)")
						group.leave()
						return
					}

					else {
						if let decodedResponse = try? JSONDecoder().decode([DBProfile].self, from: data) {
							
							// we have good data – go back to the main thread
							DispatchQueue.main.async {
								if decodedResponse.isEmpty {
									print("Empty result")
									group.leave()
									completion(false)
								}
								
								group.leave()
								completion(true)
							}
						}
					}
				}
			}.resume()
		}
		else {
			guard let url = URL(string: "http://127.0.0.1:5000/authenticate_user") else {
				print("Invalid URL")
				group.leave()
				completion(false)
				return
			}
			
			guard email != "" && password != "" else {
				print("Empty fields")
				group.leave()
				completion(false)
				return
			}
			
			let profile = AuthProfile(EA: self.email.lowercased(), PW: self.password)
			guard let encodedEntry = try? JSONEncoder().encode(profile) else {
				print("Failed to encode word to delete")
				group.leave()
				return
			}
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = encodedEntry
			
			//print(String(data: request.httpBody!, encoding: .utf8)!)
			
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				//result is get
				if let data = data, let dataString = String(data: data, encoding: .utf8), let httpResponse = response as? HTTPURLResponse {
					if httpResponse.statusCode != 200 {
						print("Error code: \(httpResponse.statusCode)")
						print("Response:\n\(dataString)")
						group.leave()
						completion(false)
						return
					}

					else {
						if let decodedResponse = try? JSONDecoder().decode([DBProfile].self, from: data), let user = decodedResponse.first {
							DispatchQueue.main.async {
								UserDefaults.standard.set(user.UID, forKey: "userID")
								group.leave()
								completion(true)
							}
						}
						else {
							print(dataString)
							group.leave()
							completion(false)
						}
					}
				}
			}.resume()
		}
	}
}
