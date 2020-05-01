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
	
	@ObservedObject var registerVM: RegisterVM
	
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
				InputTextField(title: "First Name", text: $registerVM.firstName)
					.keyboardType(.default)
					.unableToEndEditing()
				
				InputTextField(title: "Last Name", text: $registerVM.lastName)
					.keyboardType(.default)
				.unableToEndEditing()
				
				InputTextField(title: "Email", text: $registerVM.email)
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
				.unableToEndEditing()
				
				InputTextField(title: "Password", text: $registerVM.password)
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
					self.registerVM.register()
				}) {
					WideButtonView(text: "Register", backgroundColor: Color("Color Scheme Yellow"), foregroundColor: .black)
						.UseNiceShadow()
				}.disabled(registerVM.disableRegisterButton)
				
				if registerVM.showingIndicator {
					ActivityIndicator()
					.frame(width: 45, height: 45)
				}
			}
			
			Spacer()
			
			Button(action: {
				self.registerVM.loginVM.presentingRegisterView = false
				//self.presented = false
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
}

struct RegisterView_Previews: PreviewProvider {
	
	@State static var presented: Bool = true
	
    static var previews: some View {
		RegisterView(registerVM: RegisterVM(vm: LoginVM()))
    }
}
