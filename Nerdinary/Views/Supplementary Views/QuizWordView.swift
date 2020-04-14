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
	
	var body: some View {
		
		Button(action: {
			self.correctFunc(self.entry)
		}) {
			
			HStack {
				Spacer()
				
				Text(entry.definitions.first!)
				.foregroundColor(.white)
				.bold()
				.multilineTextAlignment(.center)
				
				Spacer()
			}
			.frame(height: 100)
			.background(Color.green)
			.cornerRadius(10)
			.padding(.horizontal)
		}
	}
}

struct QuizWordView_Previews: PreviewProvider {
	
	static var entry: Entry = Entry(headword: "Castrametation", shortdef: "Def", definitions: ["The science of setting up a camp"], functionalLabel: .noun)
	
    static var previews: some View {
		QuizWordView(entry: entry, correctFunc: testFunc)
    }
	
	static func testFunc(e: Entry) {
		print("You did it!")
	}
}
