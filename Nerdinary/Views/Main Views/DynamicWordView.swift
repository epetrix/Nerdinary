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
	var isGlobal: Bool = false
	var entry: Entry
	var deleteFunc: (Entry) -> ()
	
	var body: some View {
		
		HStack(alignment: .top) {
			
			VStack(alignment: .leading) {
				Text(entry.headword)
					.font(.largeTitle)
				
				if !showDetail {
					Text(entry.definitions[0])
				} else {
					Text("Functional Label: \(entry.functionalLabel.rawValue)")
					
					Spacer()
					
					Text("Definition 1: \(entry.definitions[0])")
						.padding(.bottom)
					Text("Definition 2: \(entry.definitions[1])")
						.padding(.bottom)
				}
			}
			
			Spacer()
			
			VStack(spacing: 10) {
				Button(action: {
					self.showDetail.toggle()
				}) {
					Image(systemName: "chevron.right.circle")
					.resizable()
					.frame(width: 30, height: 30)
					.rotationEffect(.init(degrees: self.showDetail ? 90: 0)).animation(.default)
				}
				.buttonStyle(PlainButtonStyle())
				
				if showDetail && !isGlobal {
					Button(action: {
						self.deleteFunc(self.entry)
					}) {
						Image(systemName: "xmark.circle")
						.resizable()
						.frame(width: 30, height: 30)
						.animation(.default)
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
		}
	}
}


struct DynamicWordView_Previews: PreviewProvider {
	@State static var entry: Entry = Entry(headword: "Word", shortdef: "Definition", definitions: ["Def1", "Def2"], functionalLabel: fl.noun)
	
    static var previews: some View {
		DynamicWordView(entry: entry, deleteFunc: test)
		.padding()
		.animation(.easeInOut(duration: 0.3))
    }
	
	static func test(e: Entry) {
		
	}
}
