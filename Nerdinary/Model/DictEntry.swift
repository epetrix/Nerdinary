//
//  Entry.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct DictEntry: Codable {
	
	var meta: Metadata
	var hwi: HWI
	var fl: String
	var shortdef: [String] = []
}

struct Metadata: Codable {

	var id: String = ""
	var uuid: String = ""
	var sort: String = ""
	var src: String = ""
	var section: String = ""
	var stems: [String] = []
	var offensive: Bool
}

struct HWI: Codable {
	
	var hw: String
}

struct ShortDefinition: Codable {

	var defs: [String] = []
}
