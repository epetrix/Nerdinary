//
//  DynamicWordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct DynamicWordView: View {
	
	@ObservedObject var vm: ViewModel
	
	var body: some View {
		
		HStack(alignment: .top) {
			
			VStack(alignment: .leading) {
				Text(vm.entry.headword)
					.font(.largeTitle)
				
				if !vm.showDetail {
					Text(vm.entry.definitions[0])
				} else {
					Text("Functional Label: \(vm.entry.functionalLabel.rawValue)")
					
					Spacer()
					
					Text("Definition 1: \(vm.entry.definitions[0])")
						.padding(.bottom)
					Text("Definition 2: \(vm.entry.definitions[1])")
						.padding(.bottom)
				}
			}
			
			Spacer()
			
			VStack(spacing: 15) {
				Button(action: {
					self.vm.showDetail.toggle()
				}) {
					Image(systemName: "chevron.right.circle")
					.resizable()
					.frame(width: 30, height: 30)
						.rotationEffect(.init(degrees: self.vm.showDetail ? 90: 0)).animation(.default)
				}
				.buttonStyle(PlainButtonStyle())
				
				if vm.showDetail && !vm.isGlobal {
					Button(action: {
						self.vm.deleteFunc(self.vm.entry)
					}) {
						Image(systemName: "xmark.circle")
						.resizable()
						.frame(width: 30, height: 30)
						.animation(.default)
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
		}
	}
}

extension DynamicWordView {
	
	class ViewModel: ObservableObject {
		
		@Published var showDetail: Bool = false
		var isGlobal: Bool = false
		var entry: Entry
		var deleteFunc: (Entry) -> ()
		
		init(isGlobal: Bool, entry: Entry, deleteFunc: @escaping (Entry) -> ()) {
			self.isGlobal = isGlobal
			self.entry = entry
			self.deleteFunc = deleteFunc
		}
	}
}

struct DynamicWordView_Previews: PreviewProvider {
	@State static var entry: Entry = Entry(headword: "Word", shortdef: "Definition", definitions: ["Def1", "Def2"], functionalLabel: fl.noun)
	
    static var previews: some View {
		DynamicWordView(vm: .init(isGlobal: false, entry: entry, deleteFunc: self.test))
		.padding()
		.animation(.easeInOut(duration: 0.3))
    }
	
	static func test(e: Entry) {
		
	}
}
