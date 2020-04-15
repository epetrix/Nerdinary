//
//  DBEntryIn.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/14/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct DBEntryIn: Codable {
	var word: String
	var type: String
	var primary_def: String
	var secondary_def: String
}
