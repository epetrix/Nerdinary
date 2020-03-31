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
		GeometryReader { geometry in
			ScrollView(.vertical, showsIndicators: false) {
				ForEach(self.entries, id: \.meta.uuid) { entry in
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

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            content
				.padding(.horizontal)
            Divider()
			.offset(x: 20)
        }
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
