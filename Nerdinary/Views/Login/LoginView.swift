//
//  LoginView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/10/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
	
	@EnvironmentObject var viewRouter: ViewRouter
	
	@State private var email = ""
	@State private var password = ""
	@State var presentingRegisterView: Bool = false
	@State var failedToLogin: Bool = false
	
    var body: some View {
		VStack {
			
			Text("Nerdinary")
				.foregroundColor(.white)
				.font(.system(size: 48))
				.bold()
				.UseNiceShadow()
				.padding(.top)
			
			Spacer()
			
			VStack(spacing: 20) {
				
				InputTextField(title: "Email", text: $email)
				
				InputTextField(title: "Password", text: $password, secure: true)
				
				Spacer().frame(height: 40)
				
				Button(action: {
					UIApplication.shared.endEditing()
					self.login()
				}) {
					WideButtonView(text: "Login")
					.UseNiceShadow()
				}
			}
			.padding([.leading, .trailing], 30) //should refactor this for geometry reader at some point to make more modular
			.alert(isPresented: $failedToLogin) {
				Alert(title: Text("Failed to login"), message: Text("Please try again."), dismissButton: .default(Text("Okay")))
			}
			
			Spacer()
			
			RegisterButton(presenting: $presentingRegisterView)
		}
		.background(LinearGradient(gradient: Gradient(colors: [Color("Gradient Purple"), Color("Gradient Blue")]), startPoint: .top, endPoint: .bottom)
		.edgesIgnoringSafeArea(.all))
		.ableToEndEditing()
		.onAppear {
			let useBiometrics = UserDefaults.standard.bool(forKey: "UseBiometricsToLogin")
			if useBiometrics {
				self.loginWithBiometrics()
			}
		}
		
    }
	
	func login() {
		
//		if UserDefaults.standard.bool(forKey: "UserIsLoggedIn") {
//			self.viewRouter.currentPage = .main
//			return
//		}
	
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
			guard let url = URL(string: "http://127.0.0.1:5000/user") else {
				print("Invalid URL")
				group.leave()
				completion(false)
				return
			}
			
			let uid = UserDefaults.standard.integer(forKey: "userID")
			if uid == 0 {
				print("Invalid User ID")
				group.leave()
				completion(false)
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
		} else {
			do {
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
				
				let profile = AuthProfile(EA: self.email, PW: self.password)
				
				var request = URLRequest(url: url)
				request.httpMethod = "POST"
				request.addValue("application/json", forHTTPHeaderField: "Content-Type")
				request.httpBody = try JSONEncoder().encode(profile)
				
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
							if let decodedResponse = try? JSONDecoder().decode([DBUserIn].self, from: data) {
								
								// we have good data – go back to the main thread
								DispatchQueue.main.async {
									if decodedResponse.isEmpty {
										print("Empty result")
										group.leave()
										completion(false)
									}
									
									UserDefaults.standard.set(decodedResponse.first!.user_id, forKey: "userID")
									
									group.leave()
									completion(true)
								}
							}
						}
					}
				}.resume()
			} catch {
				group.leave()
			}
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	
	@State static var isUnlocked: Bool = false
	
    static var previews: some View {
		LoginView().environmentObject(ViewRouter())
    }
}
