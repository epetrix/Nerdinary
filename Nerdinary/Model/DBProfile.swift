//
//  DBProfile.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

//Intended to temporarily store user's profile information and words

import SwiftUI

struct DBProfile {
	var userdata: UserData
	var entries: [DBEntryOut]
}

struct UserData {
	var username: String
	var password: String
}
