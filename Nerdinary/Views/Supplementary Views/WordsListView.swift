//
//  WordsListView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/15/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct WordsListView: View {
	
	@Binding var entries: [DBEntry] //TODO: - Change this to DBEntry
	var loadMethod: () -> ()
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView(.vertical, showsIndicators: false) {
				ForEach(self.entries, id: \.id) { entry in
					DynamicWordView(entry: entry)
					.modifier(ListRowModifier())
					.animation(.easeInOut(duration: 0.3))
				}
				.frame(width: geometry.size.width)
			}
			.onAppear(perform: self.loadMethod)
		}
	}
}

struct WordsListView_Previews: PreviewProvider {
	
	@State static var entries: [DBEntry] = [DBEntry(headword: "Word", shortdef: "Definition", definitions: ["Def1", "Def2"], functionalLabel: fl.noun)]
	
    static var previews: some View {
		WordsListView(entries: $entries, loadMethod: testFunc)
    }
	
	static func testFunc() {
		
	}
}
