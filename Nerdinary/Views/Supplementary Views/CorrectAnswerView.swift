//
//  CorrectAnswerView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/15/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct CorrectAnswerView: View {
	
	@Binding var isPresented: Bool
	var replayFunc: () -> ()
	
	var body: some View {
		
		Button(action: {
			self.isPresented = false
			self.replayFunc()
		}) {
			
			HStack {
				Spacer()
				
				Text("Correct! Play Again?")
				.bold()
				.foregroundColor(.white)
				
				Spacer()
			}
			.frame(height: 50)
			.background(Color.blue)
			.cornerRadius(10)
			.padding(.horizontal)
		}
		.transition(.opacity) //TODO: - Animation gets stuck halfway through for a tiny bit
	}
}

struct CorrectAnswerView_Previews: PreviewProvider {
	
	@State static var presented: Bool = true
	
    static var previews: some View {
		CorrectAnswerView(isPresented: $presented, replayFunc: test)
    }
	
	static func test() {
		
	}
}
