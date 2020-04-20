//
//  DBEntryIn.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/14/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct DBEntryIn: Codable { //used in loading words from DB
	var word: String
	var TYP: String
	var PD: String
	var SD: String
}
