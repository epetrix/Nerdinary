//
//  RegisterButton.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct RegisterButton: View {
	
	@Binding var presenting: Bool
	
	var body: some View {
		VStack {
			Button(action: {
				self.presenting = true
			}) {
				Text("Don't have an account? Register here")
					.foregroundColor(.black)
			}
			.sheet(isPresented: $presenting) {
				RegisterView(presented: self.$presenting)
			}
		}
	}
}

struct RegisterButton_Previews: PreviewProvider {
	@State static var presentingRegisterView: Bool = false
	
    static var previews: some View {
		RegisterButton(presenting: $presentingRegisterView)
    }
}
