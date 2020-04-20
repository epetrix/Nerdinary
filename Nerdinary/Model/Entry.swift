//
//  Entry.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/10/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct Entry: Equatable, Hashable { //Entry model for use in the app
	var id = UUID()
	var headword: String
	var shortdef: String
	var definitions: [String] = []
	var functionalLabel: fl
	
	var fromGlobalNerdinary: Bool = false
}

extension Entry {
	init(e: DBEntry) {
		self.headword = e.WRD
		self.shortdef = "shortdef missing"
		self.definitions.append(e.PD)
		self.definitions.append(e.SD)
		self.functionalLabel = { () -> fl in
			switch e.TYP {
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
		self.fromGlobalNerdinary = e.SCP == "GLOBAL"
	}
}
