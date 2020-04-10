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
	
	@State private var biometricToggle: Bool = false
	@State private var darkMode: Bool = false
	
	var body: some View {
		VStack {
			Text("Settings")
				.font(.largeTitle)
			
			Spacer()
			
			Toggle(isOn: $biometricToggle) { //giving this a shadow breaks it
				Text("Use Biometrics")
			}
			.padding(.leading, 5)
			.toggleStyle(NerdToggleStyle())
			.onAppear {
				self.biometricToggle = UserDefaults.standard.bool(forKey: "UseBiometricsToLogin")
				
				if self.biometricToggle && UserDefaults.standard.bool(forKey: "UserIsLoggedIn") {
					//self.authenticate()
					//UserDefaults.standard.set(self.biometricToggle, forKey: "UseBiometricsToLogin")
					return
				}
			}
			
			Toggle(isOn: $darkMode) {
				Text("Dark Mode")
			}
			.padding(.leading, 5)
			.toggleStyle(NerdToggleStyle())
			
			Spacer()
			
			HStack(spacing: 10) {
			
				Button(action: {
					//
				}) {
					WideButtonView(text: "Delete Account", backgroundColor: .red, cornerRadius: 4, systemFontSize: 24)
				}
				
				Button(action: {
					UserDefaults.standard.set(false, forKey: "UserIsLoggedIn")
					UserDefaults.standard.set(false, forKey: "UseBiometricsToLogin")
					self.viewRouter.currentPage = .login
				}) {
					WideButtonView(text: "Logout", backgroundColor: .blue, cornerRadius: 4, systemFontSize: 24)
				}
			}
			.padding([.horizontal, .bottom])
		}
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
