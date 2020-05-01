//
//  LocalWordsView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct LocalWordsView: View {
	
	@ObservedObject var localWordsVM = LocalWordsVM()
	
    var body: some View {
        
		GeometryReader { geometry in
			VStack {
				
				HStack {
					Text("My Nerdinary")
						.font(.largeTitle)
						.bold()
						.foregroundColor(.white)
					
					Spacer()
				}
				.padding([.leading, .top])
				
				WordsListView(entries: self.$localWordsVM.entries, loadMethod: self.localWordsVM.loadLocalWords)
				
				Button(action: {
					self.localWordsVM.presentNewWordView = true
				}) {
					WideButtonView(text: "Add Word", backgroundColor: Color("Color Scheme Yellow"), foregroundColor: .black, cornerRadius: 4)
					.padding([.leading, .trailing, .bottom])
				}
				.sheet(isPresented: self.$localWordsVM.presentNewWordView) {
//					NewWordView(loadFunc: self.localWordsVM.loadLocalWords, presenting: self.$localWordsVM.presentNewWordView)
					NewWordView(newWordVM: NewWordVM(vm: self.localWordsVM))
				}
			}
			.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
		}
    }
}

struct LocalWordsView_Previews: PreviewProvider {
	
    static var previews: some View {
        LocalWordsView()
    }
}
