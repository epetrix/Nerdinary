//
//  QuizWordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/14/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct QuizWordView: View {
	
	var entry: Entry
	var correctFunc: (Entry) -> ()
	
	@Binding var flipped: Bool
	
	
	var body: some View {
		
		Button(action: {
			self.correctFunc(self.entry)
			self.flipped.toggle()
		}) {
			
			HStack {
				Spacer()
				
				if flipped { //doing it this way instead of ternary inside text because it makes it look like the text is actually on the back
					Text(entry.headword)
					.foregroundColor(.white)
					.bold()
					.multilineTextAlignment(.center)
					.rotation3DEffect(Angle(degrees: 180), axis: (x: CGFloat(10), y: .zero, z: .zero))
					//.transition(.opacity)
				} else {
					Text(entry.definitions.first!)
					.foregroundColor(.white)
					.bold()
					.multilineTextAlignment(.center)
					//.transition(.opacity)
				}
				
//				Text(flipped ? entry.headword: entry.definitions.first!)
//				.foregroundColor(.white)
//				.bold()
//				.multilineTextAlignment(.center)
//				.rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(10), y: CGFloat(0), z: CGFloat(0)))
				
				Spacer()
			}
			.frame(height: 100)
			.background(Color.green)
			.cornerRadius(10)
			.padding(.horizontal)
		}
		.rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(10), y: CGFloat(0), z: CGFloat(0)))
		.animation(.default) // implicitly applying animation
	}
}

struct QuizWordView_Previews: PreviewProvider {
	
	static var entry: Entry = Entry(headword: "Castrametation", shortdef: "Def", definitions: ["The science of setting up a camp"], functionalLabel: .noun)
	
	@State static var flipped: Bool = false
	
    static var previews: some View {
		QuizWordView(entry: entry, correctFunc: testFunc, flipped: $flipped)
    }
	
	static func testFunc(e: Entry) {
		print("You did it!")
	}
}
