//
//  Entry.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/10/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct Entry: Equatable, Hashable {
	var id = UUID()
	var headword: String
	var shortdef: String
	var definitions: [String] = []
	var functionalLabel: fl
	
	var fromGlobalNerdinary: Bool = false
}

extension Entry {
	init(e: DBEntryIn) {
		self.headword = e.word
		self.shortdef = "shortdef missing"
		self.definitions.append(e.primary_def)
		self.definitions.append(e.secondary_def)
		self.functionalLabel = { () -> fl in
			switch e.type {
			case "Noun":
				return fl.noun
			case "Verb":
				return fl.verb
			case "Adjective":
				return fl.adjective
			case "Adverb":
				return fl.adverb
			default:
				return fl.noun
			}
		}()
	}
}
