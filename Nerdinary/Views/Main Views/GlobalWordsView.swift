//
//  GlobalWordsView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct GlobalWordsView: View {
	
	@ObservedObject var globalWordsVM = GlobalWordsVM()
	
    var body: some View {
		GeometryReader { geometry in
			VStack {
				
				HStack {
					Text("Global Nerdinary")
						.font(.largeTitle)
						.bold()
						.foregroundColor(.white)
					
					Spacer()
				}
				.padding([.leading, .top])
				
				WordsListView(entries: self.$globalWordsVM.entries, loadMethod: self.globalWordsVM.loadGlobalWords, isGlobal: true)
			}
			.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
		}
    }
}

struct GlobalWordsView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalWordsView()
    }
}
