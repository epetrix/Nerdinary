//
//  WordsListView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/15/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct WordsListView: View {
	
	@Binding var entries: [Entry] = [Entry]()
	var loadMethod: () -> ()
	
	var body: some View {
		List {
			ForEach(entries, id: \.meta.uuid) { entry in
				ShortWordView(headword: entry.hwi.hw, definition: entry.shortdef.first ?? "Error")
			}
		}
		.onAppear(perform: loadMethod)
	}
}

struct WordsListView_Previews: PreviewProvider {
    static var previews: some View {
        WordsListView()
    }
}
