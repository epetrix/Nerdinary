//
//  ViewExtensionsAndModifiers.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

//MARK: - View

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

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            content
				.padding(.horizontal)
            Divider()
			.offset(x: 20)
        }
    }
}

//MARK: - Editing

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK: - Style

struct NerdToggleStyle: ToggleStyle {
    var onColor = Color.green
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
		HStack {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 29)
				.UseNiceShadow()
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(Animation.easeInOut(duration: 0.2))
                .onTapGesture { configuration.isOn.toggle() }
				.padding(.trailing)
			
			configuration.label // The text (or view) portion of the Toggle
				.font(.system(size: 18))
			
			Spacer()
        }
        .font(.title)
    }
}
