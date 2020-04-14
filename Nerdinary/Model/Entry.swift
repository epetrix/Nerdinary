//
//  Entry.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/10/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct Entry: Equatable {
	var id = UUID()
	var headword: String
	var shortdef: String
	var definitions: [String]
	var functionalLabel: fl
	
	var fromGlobalNerdinary: Bool = false
}
