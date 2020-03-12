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
	
	@State private var username = ""
	@State private var password = ""
	@State var unlocked: Bool = false
	
    var body: some View {
		VStack {
			
			Text("Nerdinary")
				.foregroundColor(.white)
				.font(.system(size: 48))
				.bold()
				.shadow(radius: 10, x: 20, y: 10)
			
			Spacer()
			
			VStack(spacing: 20) {
				TextField("Username", text: $username)
				.padding()
				.background(Color("TextFieldColor"))
				.cornerRadius(20)
				.shadow(radius: 10, x: 20, y: 10)
				
				SecureField("Password", text: $username)
				.padding()
				.background(Color("TextFieldColor"))
				.cornerRadius(20)
				.shadow(radius: 10, x: 20, y: 10)
				
				Button(action: {
					UIApplication.shared.endEditing()
					self.login()
				}) {
					HStack {
						Spacer()

						Text("Login")
						.foregroundColor(.white)
						.font(.system(size: 24))
						.padding([.top, .bottom], 5)

						Spacer()
					}
					.background(Color.green)
					.cornerRadius(15)
					.padding([.leading, .trailing], 30)
					.padding(.top, 40)
					.shadow(radius: 10, x: 20, y: 10)

				}
				
//				Button(action: {
//					self.authenticate()
//				}) {
//					HStack {
//						Spacer()
//
//						Text("Use FaceID")
//						.foregroundColor(.white)
//						.font(.system(size: 24))
//							.padding(.top, 5)
//							.padding(.bottom, 5)
//
//						Spacer()
//					}
//					.background(Color.blue)
//					.cornerRadius(4)
//
//				}
			}
			.padding(.leading, 30) //should refactor this for geometry reader at some point to make more modular
			.padding(.trailing, 30)
			
			Spacer()
			
			passwordAndRegisterButtons()
		}
		.background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
		.edgesIgnoringSafeArea(.all))
    }
	
	func login() {
//		unlocked = true
		self.viewRouter.currentPage = .main
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

struct passwordAndRegisterButtons: View {
	
	var body: some View {
		VStack {
			Button(action: {
				//
			}) {
				Text("Don't have an account? Register here")
					.foregroundColor(.black)
				//.underline()
			}
			
//			Button(action: {
//				//
//			}) {
//				Text("Forgot password? Click here")
//				.underline()
//			}
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	
	@State static var isUnlocked: Bool = false
	
    static var previews: some View {
		LoginView().environmentObject(ViewRouter())
    }
}
