//
//  GlobalWordsView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct GlobalWordsView: View {
	
	@State private var entries: [Entry] = [Entry]()
	
    var body: some View {
        WordsListView(entries: entries, loadMethod: loadGlobalWords)
    }
	
	func loadGlobalWords() {
		
	}
}

struct GlobalWordsView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalWordsView()
    }
}
