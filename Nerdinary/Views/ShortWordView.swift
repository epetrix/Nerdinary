//
//  WordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct ShortWordView: View {
	
	var headword: String
	var definition: String
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(headword)
				.font(.system(size: 32))
			
			Text(definition)
		}
	}
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        ShortWordView(headword: "Test", definition: "A difficult thing")
	}
}
