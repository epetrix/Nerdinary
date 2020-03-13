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
        
		//NavigationView {
			VStack {
				List {
					ForEach(entries, id: \.meta.uuid) { entry in
						ShortWordView(headword: entry.hwi.hw, definition: entry.shortdef.first ?? "Error")
					}
				}
				.onAppear(perform: loadLocalWords)
				
				Button(action: {
					self.presentNewWordView = true
				}) {
					HStack {
						Spacer()

						Text("Add Word")
						.foregroundColor(.white)
						.font(.system(size: 24))
							.padding(.top, 5)
							.padding(.bottom, 5)

						Spacer()
					}
					.background(Color.blue)
					.cornerRadius(4)
					.padding(.leading)
					.padding(.trailing)
					.padding(.bottom)
				}
				.sheet(isPresented: self.$presentNewWordView) {
					NewWordView(presenting: self.$presentNewWordView, entries: self.$entries)
				}
			}.navigationBarTitle("My Nerdinary")
		//}
    }
	
	func loadLocalWords() {
		
	}
}

struct LocalWordsView_Previews: PreviewProvider {
	
    static var previews: some View {
        LocalWordsView()
    }
}
