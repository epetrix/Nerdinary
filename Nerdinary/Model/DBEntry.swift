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

struct DBEntry: Codable { //used to add word to db
	
	var UID: Int //uuid
	var WRD: String //headword
//	var shortdef: String
	var PD: String //primary definition
	var SD: String //secondary definition
	var TYP: String //functional label
	var SCP: String = "GLOBAL"
}

extension DBEntry {
	private enum CodingKeys: String, CodingKey{ //used by both encode and decode, even if it's implicit
        case UID
        case WRD
        case PD
        case SD
		case TYP
		case SCP
    }
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		UID = (try container.decodeIfPresent(Int.self, forKey: .UID)) ?? 0
		WRD = try container.decode(String.self, forKey: .WRD)
		PD = try container.decode(String.self, forKey: .PD)
		SD = try container.decode(String.self, forKey: .SD)
		TYP = try container.decode(String.self, forKey: .TYP)
		SCP = (try container.decodeIfPresent(String.self, forKey: .SCP)) ?? "GLOBAL"
	}
}
