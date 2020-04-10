//
//  DBEntry.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

// Data model for words stored in the database. Different structure than DictEntry

import SwiftUI

enum fl: String {
	case noun, adjective, adverb, verb
}

struct DBEntry {
	
	var id = UUID()
	var headword: String
	var shortdef: String
	var definitions: [String]
	var functionalLabel: fl
}
