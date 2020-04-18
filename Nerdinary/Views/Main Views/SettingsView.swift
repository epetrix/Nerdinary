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
	@State private var darkMode: Int = 0
	@State var showHelp: Bool = false
	
	var body: some View {
		
		VStack {
			HStack {
				Text("Settings")
					.font(.largeTitle)
					.bold()
				
				Spacer()
			}
			.padding(.leading)
			
			Spacer()
			
			Form {
				Section(header: Text("General Settings")) {
					Toggle(isOn: $biometricToggle) { //giving this a shadow breaks it
						Text("Use Biometrics")
					}
					.padding(.leading, 5)
//					.toggleStyle(NerdToggleStyle())
					.onAppear {
						self.biometricToggle = UserDefaults.standard.bool(forKey: "UseBiometricsToLogin")
					}
				}
				
				Section(header: Text("Help")) {
					Button(action: {
						withAnimation {
							self.showHelp.toggle()
						}
					}) {
						Text("Help")
					}
					.sheet(isPresented: $showHelp) {
						HelpView()
					}
				}
			}
			
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
					UserDefaults.standard.set(0, forKey: "userID")
					self.viewRouter.currentPage = .login
				}) {
					WideButtonView(text: "Logout", backgroundColor: .blue, cornerRadius: 4, systemFontSize: 24)
				}
			}
			.padding([.horizontal, .bottom])
		}
		.onDisappear {
			UserDefaults.standard.set(self.biometricToggle, forKey: "UseBiometricsToLogin")
		}
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			SettingsView()
//			HelpView()
		}
    }
}
