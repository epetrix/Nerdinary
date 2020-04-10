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
	@State var presentingRegisterView: Bool = false
	
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
				
				InputTextField(title: "Username", text: $username)
				
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
			
			Spacer()
			
			RegisterButton(presenting: $presentingRegisterView)
		}
		.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Purple"), Color("Color Scheme Blue")]), startPoint: .top, endPoint: .bottom)
		.edgesIgnoringSafeArea(.all))
		.ableToEndEditing()
		
    }
	
	func login() {
		
//		if UserDefaults.standard.bool(forKey: "UserIsLoggedIn") {
//			self.viewRouter.currentPage = .main
//			return
//		}
		
		//TODO: - update this with db check
		var success: Bool = true
		
		if success {
			UserDefaults.standard.set(true, forKey: "UserIsLoggedIn")
			self.viewRouter.currentPage = .main
		}
	}
	
	func authenticate() {
		print("authenticating")
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
						self.viewRouter.currentPage = .main
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
	
	@State static var isUnlocked: Bool = false
	
    static var previews: some View {
		LoginView().environmentObject(ViewRouter())
    }
}
