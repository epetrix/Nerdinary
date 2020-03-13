//
//  LocalWordsView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct LocalWordsView: View {
	
	@State private var entries: [Entry] = [Entry]() //[Entry(meta: Metadata(offensive: false), hwi: HWI(hw: "Cool"), shortdef: ["Mike is a cool guy"])]
	
	@State private var presentNewWordView: Bool = false
	
    var body: some View {
        
		VStack {
			WordsListView(entries: $entries, loadMethod: loadLocalWords)
			
			Button(action: {
				self.presentNewWordView = true
			}) {
				WideButtonView(text: "Add Word", backgroundColor: .blue, cornerRadius: 4)
				.padding([.leading, .trailing, .bottom])
			}
			.sheet(isPresented: self.$presentNewWordView) {
				NewWordView(presenting: self.$presentNewWordView, entries: self.$entries)
			}
		}.navigationBarTitle("My Nerdinary")
    }
	
	func loadLocalWords() {
		print("Displaying local words")
	}
}

struct WordsListView: View {
	
	@Binding var entries: [Entry]
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

struct LocalWordsView_Previews: PreviewProvider {
	
    static var previews: some View {
        LocalWordsView()
    }
}
