//
//  RegisterView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/12/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
	
	@State var email = ""
	@State var password = ""
	@State var firstName = ""
	@State var lastName = ""
	@State var showingIndicator: Bool = false
	@State var disableRegisterButton: Bool = false
	
	@Binding var presented: Bool
	
    var body: some View {
		VStack(spacing: 20) {
			
			Text("Create a new Account")
				.font(.largeTitle)
				.foregroundColor(.white)
				.bold()
				.UseNiceShadow()
				.padding(.top)
			
			Spacer()
			
			InputTextField(title: "First Name", text: $firstName)
				.keyboardType(.default)
			
			InputTextField(title: "Last Name", text: $lastName)
				.keyboardType(.default)
			
			InputTextField(title: "Email", text: $email)
				.keyboardType(.emailAddress)
			
			InputTextField(title: "Password", text: $password)
				.keyboardType(.default)
			
			ZStack {
				Button(action: {
					print("Hello")
					self.register()
				}) {
					WideButtonView(text: "Register", backgroundColor: Color("Color Scheme Yellow"), foregroundColor: .black)
						.UseNiceShadow()
				}.disabled(disableRegisterButton)
				
				if showingIndicator {
					ActivityIndicator()
					.frame(width: 45, height: 45)
				}
			}
			
			Spacer()
			
			Button(action: {
				self.presented = false
			}) {
				Text("Already have an account? Login here")
				.foregroundColor(.black)
			}
		}
		.padding([.leading, .trailing], 30)
		.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom)
		.edgesIgnoringSafeArea(.all))
		.ableToEndEditing()
    }
	
	func register() {
		let group = DispatchGroup()
		group.enter()
		
		do {
			showingIndicator = true
			disableRegisterButton = true
			let uid = Int.random(in: 1..<10000)
			
			print("Adding user to DB...")
			
			guard let url = URL(string: "http://127.0.0.1:5000/user") else {
				print("Invalid URL")
				group.leave()
				return
			}
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type") //THIS IS SUPER NECESSARY
			
			let profile = DBProfile(UID: uid, FN: self.firstName, LN: self.lastName, EA: self.email, PW: self.password)
			
			request.httpBody = try JSONEncoder().encode(profile)
			
			//print(String(data: request.httpBody!, encoding: .utf8)!)
			
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				
				if let error = error {
					print("Error occurred: \(error)")
					group.leave()
					return
				}
				
				if let data = data, let dataString = String(data: data, encoding: .utf8) {
					DispatchQueue.main.async {
						//print("Response data string:\n \(dataString)")
						UserDefaults.standard.set(uid, forKey: "userID")
						self.showingIndicator = false
						self.disableRegisterButton = false
						if dataString == "{}" {
							self.presented = false
						}
						group.leave()
					}
				}
			}.resume()
		}
		catch {
			group.leave()
			fatalError("Couldn't encode JSON")
		}
	}
}

struct RegisterView_Previews: PreviewProvider {
	
	@State static var presented: Bool = true
	
    static var previews: some View {
		RegisterView(presented: $presented)
    }
}
