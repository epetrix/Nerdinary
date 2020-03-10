//
//  LoginView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/10/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct LoginView: View {
	
	@State private var username = ""
	@State private var password = ""
	
    var body: some View {
		VStack {
			
			TextField("Username", text: $username)
			
			TextField("Password", text: $username)
		}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
