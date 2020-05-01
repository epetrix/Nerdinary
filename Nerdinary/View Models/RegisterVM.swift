//
//  RegisterVM.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 5/1/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

class RegisterVM: ObservableObject {
	
	@Published var email = ""
	@Published var password = ""
	@Published var firstName = ""
	@Published var lastName = ""
	@Published var showingIndicator: Bool = false
	@Published var disableRegisterButton: Bool = false
	
	@ObservedObject var loginVM: LoginVM
	
	init(vm: LoginVM) {
		self.loginVM = vm
	}
	
	func register() {
		let group = DispatchGroup()
		group.enter()
		
		showingIndicator = true
		disableRegisterButton = true
		
		print("Adding user to DB...")
		
		guard let url = URL(string: "http://127.0.0.1:5000/user") else {
			print("Invalid URL")
			group.leave()
			return
		}
		
		guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
			print("Not all fields filled")
			group.leave()
			return
		}
		
		let profile = DBProfile(UID: 0, FN: self.firstName, LN: self.lastName, EA: self.email.lowercased(), PW: self.password)
		guard let encodedEntry = try? JSONEncoder().encode(profile) else {
			print("Failed to encode word to delete")
			group.leave()
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type") //THIS IS SUPER NECESSARY
		
		request.httpBody = encodedEntry
		
		//print(String(data: request.httpBody!, encoding: .utf8)!)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if let error = error {
				print("Error occurred: \(error)")
				group.leave()
				return
			}
			
			if let data = data, let dataString = String(data: data, encoding: .utf8), let httpResponse = response as? HTTPURLResponse, let decodedResponse = try? JSONDecoder().decode([DBProfile].self, from: data), let newUser = decodedResponse.first {
				if httpResponse.statusCode != 201 {
					print("Error code: \(httpResponse.statusCode)")
					print("Response:\n\(dataString)")
					group.leave()
					self.showingIndicator = true
					self.disableRegisterButton = true
					return
				}
				else {
					DispatchQueue.main.async {
						//print("Response data string:\n \(decodedResponse)")
						UserDefaults.standard.set(newUser.UID, forKey: "userID")
						self.showingIndicator = false
						self.disableRegisterButton = false
						self.loginVM.presentingRegisterView = false
						group.leave()
					}
				}
			}
		}.resume()
	}
}
