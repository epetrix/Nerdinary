//
//  WordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct ShortWordView: View {
	var entry: DictEntry
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(entry.hwi.hw)
				.font(.system(size: 32))
			
			Text(entry.shortdef.first ?? "Error")
		}
	}
}

struct WordView_Previews: PreviewProvider {
	static var entry: DictEntry = DictEntry(meta: Metadata(offensive: false), hwi: HWI(hw: "Test"), fl: "Adjective", shortdef: ["A difficult thing"])
	
    static var previews: some View {
		ShortWordView(entry: entry)
	}
}
