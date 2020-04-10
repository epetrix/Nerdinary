//
//  LocalWordsView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct LocalWordsView: View {
	
	@State private var entries: [Entry] = [Entry]()
	
//	@State private var entries: [DictEntry] = [
//		DictEntry(meta: Metadata(uuid: "1", offensive: false), hwi: HWI(hw: "Mike"), fl: "Noun", shortdef: ["Mike is a cool human"]),
//		DictEntry(meta: Metadata(uuid: "2", offensive: false), hwi: HWI(hw: "Eden"), fl: "Noun", shortdef: ["Eden is a cool human"]),
//		DictEntry(meta: Metadata(uuid: "3", offensive: false), hwi: HWI(hw: "Celeste"), fl: "Noun", shortdef: ["Celeste is a cool human"]),
//		DictEntry(meta: Metadata(uuid: "4", offensive: false), hwi: HWI(hw: "Micah"), fl: "Noun", shortdef: ["Micah is a cool human"])
//	]
	
	@State private var presentNewWordView: Bool = false
	
    var body: some View {
        
		VStack {
			HStack {
				Text("My Nerdinary")
					.font(.largeTitle)
					.bold()
				
				Spacer()
			}
			.padding([.leading, .top])
			
			WordsListView(entries: $entries, loadMethod: loadLocalWords)
			
			Button(action: {
				self.presentNewWordView = true
			}) {
				WideButtonView(text: "Add Word", backgroundColor: .blue, cornerRadius: 4)
				.padding([.leading, .trailing, .bottom])
			}
			.sheet(isPresented: self.$presentNewWordView) {
				NewWordView(loadFunc: self.loadLocalWords, presenting: self.$presentNewWordView)
			}
		}
    }
	
	func loadLocalWords() {
		
		//TODO: - Remove transport key from info.plist, not safe for app store
		print("Displaying local words")
		
		/*guard let url = URL(string: "http://127.0.0.1:5000/user/1001") else {
					print("Invalid URL")
					return
				}
				
		let request = URLRequest(url: url)
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			// step 4
			
			if let data = data {
				
				print("JSON String:\n \(String(data: data, encoding: .utf8) ?? "error")")
				
				return
				
				/*if let decodedResponse = try? JSONDecoder().decode([DictEntry].self, from: data) {
					
					// we have good data – go back to the main thread
					DispatchQueue.main.async {
//						 update our UI
						self.homographs = decodedResponse

						self.headWord = self.homographs.first?.hwi.hw ?? "error"

						self.definitions = []
						for entry in self.homographs {
							let partOfSpeech = entry.fl.uppercased()
							let firstShortDef = entry.shortdef.first ?? "error"
							self.definitions.append("\(partOfSpeech): \(firstShortDef)")
						}
						
					}

					// everything is good, so we can exit
					return
				} else {}
				*/
			} else {}

			// if we're still here it means there was a problem
			print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
			//self.wordDoesntExistAlert = true
			print("Failed")
			
		}.resume()*/
	}
}

struct LocalWordsView_Previews: PreviewProvider {
	
    static var previews: some View {
        LocalWordsView()
    }
}
