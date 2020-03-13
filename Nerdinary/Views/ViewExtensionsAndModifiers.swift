//
//  ViewExtensionsAndModifiers.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

extension View {
	func ableToEndEditing() -> some View {
		self.modifier(canEndEditing())
	}
	
	func UseNiceShadow() -> some View {
		self.modifier(NiceShadow())
	}
}

struct NiceShadow: ViewModifier {
	func body(content: Content) -> some View {
		content
		.shadow(radius: 10, x: 20, y: 10)
	}
}

struct canEndEditing: ViewModifier {
	func body(content: Content) -> some View {
		content.onTapGesture {
			UIApplication.shared.endEditing()
		}
	}
}
