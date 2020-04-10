//
//  DynamicWordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct DynamicWordView: View {
	
	@State var showDetail: Bool = false
	var entry: Entry
	
	var body: some View {
		
		HStack(alignment: .top) {
			
			VStack(alignment: .leading) {
				Text(entry.headword)
					.font(.largeTitle)
				
				if !showDetail {
					Text(entry.shortdef)
				} else {
					Text("Functional Label: \(entry.functionalLabel.rawValue)")
					Spacer()
					Text("Sense: Definition 1")
					Text("Sense: Definition 2")
					Text("Sense: Definition 3")
					Text("Sense: Definition 4")
					Spacer()
					Text("Etymology: 14th Century Anglo Saxon")
				}
			}
			
			Spacer()
			
			Button(action: {
				self.showDetail.toggle()
			}) {
				Image(systemName: "chevron.right.circle")
				.resizable()
				.frame(width: 30, height: 30)
				.rotationEffect(.init(degrees: self.showDetail ? 90: 0)).animation(.default)
			}
			.buttonStyle(PlainButtonStyle())
		}
	}
}


struct DynamicWordView_Previews: PreviewProvider {
	@State static var entry: Entry = Entry(headword: "Word", shortdef: "Definition", definitions: ["Def1", "Def2"], functionalLabel: fl.noun)
	
    static var previews: some View {
        DynamicWordView(entry: entry)
		.padding()
		.animation(.easeInOut(duration: 0.3))
    }
}
