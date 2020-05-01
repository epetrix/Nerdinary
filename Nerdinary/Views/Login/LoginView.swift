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
	
	@ObservedObject var loginVM = LoginVM()
	
    var body: some View {
		VStack {
			
			Text("Nerdinary")
				.foregroundColor(.white)
				.font(.system(size: 48))
				.bold()
				.UseNiceShadow()
				.padding(.top)
			
			Image("icon")
				.resizable()
				.clipShape(Circle())
				.frame(width: 200, height: 200, alignment: .center)
				.padding(.bottom)
				.UseNiceShadow()
			
			//Spacer()
			
			VStack(spacing: 20) {
				
				InputTextField(title: "Email", text: $loginVM.email)
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
				
				InputTextField(title: "Password", text: $loginVM.password, secure: true)
					.autocapitalization(.none)
				
				Spacer().frame(height: 40)
				
				Button(action: {
					UIApplication.shared.endEditing()
					self.loginVM.login()
				}) {
					WideButtonView(text: "Login", backgroundColor: Color("Color Scheme Yellow"), foregroundColor: .black)
					.UseNiceShadow()
				}
			}
			.padding([.leading, .trailing], 30) //should refactor this for geometry reader at some point to make more modular
			.alert(isPresented: $loginVM.failedToLogin) {
				Alert(title: Text("Failed to login"), message: Text("Please try again."), dismissButton: .default(Text("Okay")))
			}
			
			Spacer()
			
			RegisterButton(presenting: $loginVM.presentingRegisterView)
		}
		.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom)
		.edgesIgnoringSafeArea(.all))
		.ableToEndEditing()
		.onAppear {
			let useBiometrics = UserDefaults.standard.bool(forKey: "UseBiometricsToLogin")
			if useBiometrics {
				self.loginVM.loginWithBiometrics()
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
