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
				
				WordsListView(entries: self.$entries, loadMethod: self.loadLocalWords)
				
				Button(action: {
					self.presentNewWordView = true
				}) {
					WideButtonView(text: "Add Word", backgroundColor: Color("Color Scheme Yellow"), foregroundColor: .black, cornerRadius: 4)
					.padding([.leading, .trailing, .bottom])
				}
				.sheet(isPresented: self.$presentNewWordView) {
					NewWordView(loadFunc: self.loadLocalWords, presenting: self.$presentNewWordView)
				}
			}
			.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
		}
    }
	
	func loadLocalWords() {
		
		let group = DispatchGroup()
		group.enter()
		
		//TODO: - Remove transport key from info.plist, not safe for app store
		print("Displaying local words")
		
		let uid = UserDefaults.standard.integer(forKey: "userID")
		if uid == 0 {
			print("Invalid User ID")
			group.leave()
			return
		}
		
		guard let url = URL(string: "http://127.0.0.1:5000/user_words/\(uid)") else {
			print("Invalid URL")
			group.leave()
			return
		}
				
		let request = URLRequest(url: url)
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			// step 4
			
			if let data = data {
				
				//print("JSON String:\n \(String(data: data, encoding: .utf8) ?? "error")")
				
				if let decodedResponse = try? JSONDecoder().decode([DBEntryIn].self, from: data) {
					
					// we have good data – go back to the main thread
					DispatchQueue.main.async {
						if decodedResponse.isEmpty {
							print("Empty result")
						}
//						 update our UI
						self.entries.removeAll()
						
						for entry in decodedResponse {
							self.entries.append(Entry(e: entry))
						}
						
						group.leave()
						
					}

					// everything is good, so we can exit
					return
				} else {
					print("problem with decoded response")
					group.leave()
				}
				
			} else {
				print("problem with data")
				group.leave()
			}

			// if we're still here it means there was a problem
			print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
			//self.wordDoesntExistAlert = true
			print("Failed")
			
		}.resume()
	}
}

struct LocalWordsView_Previews: PreviewProvider {
	
    static var previews: some View {
        LocalWordsView()
    }
}
