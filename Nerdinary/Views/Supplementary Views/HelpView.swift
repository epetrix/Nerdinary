//
//  HelpView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/18/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct HelpView: View {
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				Text("How to use Nerdinary:")
					.font(.largeTitle)
					.bold()
				
				ScrollView(.vertical) {
					
					VStack(alignment: .leading, spacing: 10) {
						Text("Welcome to Nerdinary")
						.bold()
						.font(.system(size: 22))
						
						Text("Our mission statement: Nerdinary aims to improve your meory and vocabulary in a fun and time-effective manner")
						.font(.system(size: 18))
						.multilineTextAlignment(.leading)
						
						Spacer()
							.frame(height: 40)
						
						Text("How to use this app:")
						.bold()
						.font(.system(size: 22))
						
						Text("1) Go to the \"Local\" page and select \"New Word\"")
							.multilineTextAlignment(.leading)
							.font(.system(size: 18))
						
						Text("2) Search for the word you are looking for, and if when the fields populate, you can add it to your nerdinary.")
							.multilineTextAlignment(.leading)
							.font(.system(size: 18))
						
						Text("3) If you want to see others' words, head to the \"Global\" Page")
							.multilineTextAlignment(.leading)
							.font(.system(size: 18))
						
						Text("4) If you want to be quizzed on some random nerdinary words, go to the \"Quiz\" page.")
							.multilineTextAlignment(.leading)
							.font(.system(size: 18))
						
						VStack(alignment: .leading, spacing: 10) {
							Spacer().frame(height: 40)
							
							Text("Contact Us:")
								.bold()
								.font(.system(size: 22))
							
							Text("If you have any questions, feel free to contact us at nerdinary001@gmail.com")
							.font(.system(size: 18))
							
							Spacer()
						}
					}
				}
				//.frame(width: geometry.size.width)
			}
			.padding()
		}
	}
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
