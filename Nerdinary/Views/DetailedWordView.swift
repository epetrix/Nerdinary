//
//  DetailedWordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct DetailedWordView: View {
	
	@Binding var entry: Entry
	
    var body: some View {
		VStack {
			Text(entry.hwi.hw)
			.font(.system(size: 32))
			.bold()
			
			List {
				ForEach(entry.shortdef, id: \.count) { def in
					Text(def)
				}
			}
		}
    }
}

struct DetailedWordView_Previews: PreviewProvider {
	
	@State static var entry = Entry(meta: Metadata(offensive: false), hwi: HWI(hw: "Cool"), shortdef: ["Mike is a cool guy", "lsklkdlksd"])
	
    static var previews: some View {
		DetailedWordView(entry: $entry)
    }
}
