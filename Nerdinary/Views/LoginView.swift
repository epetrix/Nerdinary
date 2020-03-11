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
	
	@State private var username = ""
	@State private var password = ""
	@State private var unlocked = false
	
    var body: some View {
		VStack {
			
			Text("Nerdinary")
				.font(.system(size: 48))
				.bold()
			
			Spacer()
			
			VStack(spacing: 10) {
				TextField("Username", text: $username)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				
				TextField("Password", text: $username)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				
				Button(action: {
					UIApplication.shared.endEditing()
					self.login()
				}) {
					HStack {
						Spacer()

						Text("Login")
						.foregroundColor(.white)
						.font(.system(size: 24))
							.padding(.top, 5)
							.padding(.bottom, 5)

						Spacer()
					}
					.background(Color.blue)
					.cornerRadius(4)
					
				}
				
				Button(action: {
					self.login()
				}) {
					HStack {
						Spacer()

						Text("Use FaceID")
						.foregroundColor(.white)
						.font(.system(size: 24))
							.padding(.top, 5)
							.padding(.bottom, 5)

						Spacer()
					}
					.background(Color.blue)
					.cornerRadius(4)
					
				}
			}
			.padding(.leading, 30) //should refactor this for geometry reader at some point to make more modular
			.padding(.trailing, 30)
			
			Spacer()
			
			VStack {
				Button(action: {
					//
				}) {
					Text("Don't have an account? Register here")
					.underline()
				}
				
				Button(action: {
					//
				}) {
					Text("Forgot password? Click here")
					.underline()
				}
			}
		}
    }
	
	func login() {
		unlocked = true
	}
	
	func authenticate() {
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
						self.unlocked = true
					} else {
						// there was a problem
					}
				}
			}
		} else {
			// no biometrics
		}
	}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
