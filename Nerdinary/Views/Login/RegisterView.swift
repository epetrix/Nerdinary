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
					WideButtonView(text: "Register")
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
		.background(LinearGradient(gradient: Gradient(colors: [Color("Gradient Purple"), Color("Gradient Blue")]), startPoint: .top, endPoint: .bottom)
		.edgesIgnoringSafeArea(.all))
    }
	
	func register() {
		showingIndicator = true
		disableRegisterButton = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.showingIndicator = false
			self.presented = false
		}
	}
}

struct RegisterView_Previews: PreviewProvider {
	
	@State static var presented: Bool = true
	
    static var previews: some View {
		RegisterView(presented: $presented)
    }
}
