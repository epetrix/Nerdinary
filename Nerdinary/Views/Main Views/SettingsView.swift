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
//					.toggleStyle(NerdToggleStyle())
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
					self.viewRouter.currentPage = .login
				}) {
					WideButtonView(text: "Logout", backgroundColor: .blue, cornerRadius: 4, systemFontSize: 24)
				}
			}
			.padding([.horizontal, .bottom])
		}
	}
}

struct HelpView: View {
	
	var body: some View {
		VStack {
			Text("How to use Nerdinary:")
				.font(.largeTitle)
				.bold()
			
			Spacer()
			
			Text("First, go to the \"Local\" page and select \"New Word\"")
			
			Text("Search for the word you are looking for, and if when the fields populate, you can add it to your nerdinary.")
			
			Text("If you want to see others' words, head to the \"Global\" Page")
			
			Text("If you want to be quizzed on some random nerdinary words, go to the \"Quiz\" page.")
			
			Spacer()
			Text("If you have any questions, feel free to contact us at _____")
		}
		.padding()
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			SettingsView()
			HelpView()
		}
    }
}
