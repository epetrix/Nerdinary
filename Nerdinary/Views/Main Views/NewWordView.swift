//
//  NewWordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct NewWordView: View {
	
	@ObservedObject var newWordVM: NewWordVM
	
	var body: some View {
		VStack {
			Text(newWordVM.headWord)
				.font(.system(size: 32))
				.padding(.top)
			
			HStack {
				TextField("Enter for Word", text: $newWordVM.wordToSearch)
				.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding(.trailing)
				
				Button(action: {
					UIApplication.shared.endEditing()
					self.newWordVM.loadDataFromDictionary()
				}) {
					WideButtonView(text: "Search", backgroundColor: Color("Color Scheme Orange"), foregroundColor: .white, cornerRadius: 4, systemFontSize: 20)
					.frame(width: 100)
				}
			}
			.padding(.leading)
			.padding(.trailing)
			.alert(isPresented: $newWordVM.wordDoesntExistAlert) {
				Alert(title: Text("Word doesn't exist"), message: Text("Please check your spelling and try again"), dismissButton: .default(Text("OK")))
			}
			
			List {
				ForEach(newWordVM.definitions, id: \.count) { def in
					Text(def)
				}
			}
			
			HStack {
				Button(action: {
					self.newWordVM.localVM.presentNewWordView = false
				}) {
					WideButtonView(text: "Cancel", backgroundColor: Color("Color Scheme Red"), foregroundColor: .white, cornerRadius: 4)
						.padding(.horizontal, 5)
				}
				
				ZStack {
					Button(action: {
						self.newWordVM.saveToServer()
					}) {
						WideButtonView(text: "Save", backgroundColor: Color("Color Scheme Green"), foregroundColor: .white, cornerRadius: 4)
							.padding(.horizontal, 5)
					}
					.disabled(newWordVM.definitions.isEmpty)
					
					if self.newWordVM.showingIndicator {
						ActivityIndicator()
						.frame(width: 36, height: 36)
					}
				}
			}
			.padding(.bottom)
		}
		.ableToEndEditing()
	}
}

extension NewWordView {
	init(_ vm: NewWordVM) {
		self.newWordVM = vm
	}
}

struct NewWordView_Previews: PreviewProvider {
	
	@State static var present: Bool = true
	@State static var entries: [DBEntry] = []
	static func function() {}
	
    static var previews: some View {
		NewWordView(newWordVM: NewWordVM(vm: LocalWordsVM()))
    }
}
