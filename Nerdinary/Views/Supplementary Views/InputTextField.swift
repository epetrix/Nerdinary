//
//  InputTextField.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct InputTextField: View {
	
	var title: String
	@Binding var text: String
	var secure: Bool = false
	
	@ViewBuilder
	var body: some View {
		
		if secure {
			SecureField(title, text: $text)
			.modifier(NerdInput())
		} else {
			TextField(title, text: $text)
			.modifier(NerdInput())
		}
	}
	
	private struct NerdInput: ViewModifier {
		func body(content: Content) -> some View {
			content
				.padding()
				.background(Color("TextFieldColor"))
				.cornerRadius(20)
				.UseNiceShadow()
		}
	}
}

struct InputTextField_Previews: PreviewProvider {
	@State static private var username = ""
	
    static var previews: some View {
		InputTextField(title: "Temporary Text", text: $username)
    }
}
