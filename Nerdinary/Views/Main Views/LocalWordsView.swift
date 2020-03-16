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
			HStack {
				Text("My Nerdinary")
					.font(.largeTitle)
					.bold()
				
				Spacer()
			}
			.padding([.leading, .top])
			
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
		}
    }
	
	func loadLocalWords() {
		print("Displaying local words")
	}
}

struct LocalWordsView_Previews: PreviewProvider {
	
    static var previews: some View {
        LocalWordsView()
    }
}
