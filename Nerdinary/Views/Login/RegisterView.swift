//
//  RegisterView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/12/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
	
	@State var username = ""
	@State var password = ""
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
			
			InputTextField(title: "Username", text: $username)
			
			InputTextField(title: "Password", text: $password)
			
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
		.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Purple"), Color("Color Scheme Blue")]), startPoint: .top, endPoint: .bottom)
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

struct ActivityIndicator: View {

	@State private var isAnimating: Bool = false

	var body: some View {
	GeometryReader { geometry in
		ForEach(0..<5) { index in
			Group {
			  Circle()
				.frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
				.scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
				.offset(y: geometry.size.width / 10 - geometry.size.height / 2)
			  }.frame(width: geometry.size.width, height: geometry.size.height)
				.rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
				.animation(Animation
					.timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
					.repeatForever(autoreverses: false))
			}
		}
		.aspectRatio(1, contentMode: .fit)
		.onAppear {
			self.isAnimating = true
		}
	}
}

struct RegisterView_Previews: PreviewProvider {
	
	@State static var presented: Bool = true
	
    static var previews: some View {
		RegisterView(presented: $presented)
    }
}
