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

struct DBEntryOut: Codable {
	
	var UID = "1002" //uuid
	var WRD: String //headword
//	var shortdef: String
	var PD: String //primary definition
	var SD: String //secondary definition
	var TYP: String //functional label
	var SCP: String = "GLOBAL"
}
