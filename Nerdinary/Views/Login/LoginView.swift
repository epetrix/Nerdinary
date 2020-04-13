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
	
		if authenticateDB() {
			UserDefaults.standard.set(true, forKey: "UserIsLoggedIn")
			self.viewRouter.currentPage = .main
			return
		}
		else {
			self.failedToLogin = true
		}
	}
	
	func loginWithBiometrics() {
		authenticateBiometrics() { success in
			if success && self.authenticateDB() {
				UserDefaults.standard.set(true, forKey: "UserIsLoggedIn")
				self.viewRouter.currentPage = .main
				return
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
	
	func authenticateDB() -> Bool {
		return true
	}
}

struct LoginView_Previews: PreviewProvider {
	
	@State static var isUnlocked: Bool = false
	
    static var previews: some View {
		LoginView().environmentObject(ViewRouter())
    }
}
