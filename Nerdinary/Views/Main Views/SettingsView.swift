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
					self.deleteUser()
				}) {
					WideButtonView(text: "Delete Account", backgroundColor: Color("Color Scheme Red"), cornerRadius: 4, systemFontSize: 24)
				}
				
				Button(action: {
					UserDefaults.standard.set(false, forKey: "UserIsLoggedIn")
					UserDefaults.standard.set(false, forKey: "UseBiometricsToLogin")
					UserDefaults.standard.set(0, forKey: "userID")
					self.viewRouter.currentPage = .login
				}) {
					WideButtonView(text: "Logout", backgroundColor: Color("Color Scheme Green"), cornerRadius: 4, systemFontSize: 24)
				}
			}
			.padding([.horizontal, .bottom])
		}
		.onDisappear {
			UserDefaults.standard.set(self.biometricToggle, forKey: "UseBiometricsToLogin")
		}
	}
	
	func deleteUser() {
		let group = DispatchGroup()
		group.enter()
		
		print("Deleting user...")
		
		let uid = UserDefaults.standard.integer(forKey: "userID")
		if uid == 0 {
			print("Invalid User ID")
			group.leave()
			return
		}
		
		guard let url = URL(string: "http://127.0.0.1:5000/user/\(uid)") else {
			print("Invalid URL")
			group.leave()
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		//print(String(data: request.httpBody!, encoding: .utf8)!)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if let error = error {
				print("Error occurred: \(error)")
				group.leave()
				return
			}
			
			if let data = data, let dataString = String(data: data, encoding: .utf8), let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode != 202 {
					print("Error code: \(httpResponse.statusCode)")
					print("Response:\n\(dataString)")
					//TODO: - make alert here
					group.leave()
					return
				}
				
				else {
					DispatchQueue.main.async {
						print("Response:\n\(dataString)")
						self.viewRouter.currentPage = .login
						group.leave()
					}
				}
			}
			
		}.resume()
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
