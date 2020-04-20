//
//  DBProfile.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

//Intended to temporarily store user's profile information and words

import SwiftUI

struct DBProfile: Codable {
	var UID: Int
	var FN: String
	var LN: String
	var EA: String
	var PW: String
}

extension DBProfile {
	private enum CodingKeys: String, CodingKey{
        case UID
        case FN
        case LN
        case EA
		case PW
    }
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		UID = try container.decode(Int.self, forKey: .UID)
		FN = (try container.decodeIfPresent(String.self, forKey: .FN)) ?? ""
		LN = (try container.decodeIfPresent(String.self, forKey: .LN)) ?? ""
		EA = (try container.decodeIfPresent(String.self, forKey: .EA)) ?? ""
		PW = (try container.decodeIfPresent(String.self, forKey: .PW)) ?? ""
	}
}
