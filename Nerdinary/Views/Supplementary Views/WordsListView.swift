//
//  WordsListView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/15/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct WordsListView: View {
	
	@Binding var entries: [DictEntry] //TODO: - Change this to DBEntry
	var loadMethod: () -> ()
	
	var body: some View {
		List {
			ForEach(entries, id: \.meta.uuid) { entry in
				DynamicWordView(entry: entry)
					.animation(.easeInOut(duration: 0.3))
			}
		}
		.onAppear(perform: loadMethod)
	}
}

struct WordsListView_Previews: PreviewProvider {
	
	@State static var entries: [DictEntry] = [DictEntry(meta: Metadata(offensive: false), hwi: HWI(hw: "Word"), fl: "Noun", shortdef: ["Short Definition"])]
	
    static var previews: some View {
		WordsListView(entries: $entries, loadMethod: testFunc)
    }
	
	static func testFunc() {
		
	}
}
