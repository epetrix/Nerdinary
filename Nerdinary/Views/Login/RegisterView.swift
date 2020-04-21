//
//  RegisterView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/12/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
	
	@ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
	
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
			
			VStack(spacing: 20) {
				InputTextField(title: "First Name", text: $firstName)
					.keyboardType(.default)
					.unableToEndEditing()
				
				InputTextField(title: "Last Name", text: $lastName)
					.keyboardType(.default)
				.unableToEndEditing()
				
				InputTextField(title: "Email", text: $email)
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
				.unableToEndEditing()
				
				InputTextField(title: "Password", text: $password)
					.keyboardType(.default)
					.autocapitalization(.none)
					.unableToEndEditing()
				.background(GeometryGetter(rect: $kGuardian.rects[0]))
			}
			.offset(y: kGuardian.slide).animation(.easeInOut(duration: 0.25))
			.onAppear {
				self.kGuardian.addObserver()
			}
			.onDisappear {
				self.kGuardian.removeObserver()
			}
			
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
						self.presented = false
						group.leave()
					}
				}
			}
		}.resume()
	}
}

struct RegisterView_Previews: PreviewProvider {
	
	@State static var presented: Bool = true
	
    static var previews: some View {
		RegisterView(presented: $presented)
    }
}
