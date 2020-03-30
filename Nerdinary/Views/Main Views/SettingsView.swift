//
//  Settings.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/15/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
	
	var body: some View {
		Button(action: {
			UserDefaults.standard.set(false, forKey: "UserIsLoggedIn")
			UserDefaults.standard.set(false, forKey: "UseBiometricsToLogin")
			self.viewRouter.currentPage = .login
		}) {
			Text("Logout")
		}
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
