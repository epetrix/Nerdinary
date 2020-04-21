//
//  ContentView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct DashBoard: View {
	
	@EnvironmentObject var viewRouter: ViewRouter
	
	@State var selectedView = 0
	
    var body: some View {
		TabView(selection: $selectedView) {
			LocalWordsView()
			.tabItem {
				Image(systemName: "book.circle")
					.font(.system(size: 26))
				Text("Local")
					.font(.system(size: 26))
			}.tag(0)
			
			GlobalWordsView()
			.tabItem {
				Image(systemName: "globe")
					.font(.system(size: 26))
				Text("Global")
					.font(.system(size: 26))
			}.tag(1)
			
			QuizView()
			.tabItem {
				Image(systemName: "pencil.circle")
					.font(.system(size: 26))
				Text("Quiz")
					.font(.system(size: 26))
			}.tag(2)
			
			SettingsView()
			.tabItem {
				Image(systemName: "gear")
					.font(.system(size: 26))
				Text("Settings")
					.font(.system(size: 26))
			}.tag(3)
		}
		.accentColor(Color("TabViewIconColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		DashBoard().environmentObject(ViewRouter())
    }
}
