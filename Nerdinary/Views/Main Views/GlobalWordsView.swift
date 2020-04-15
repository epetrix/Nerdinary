//
//  GlobalWordsView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct GlobalWordsView: View {
	
	@State private var entries: [Entry] = [Entry]()
	
    var body: some View {
		VStack {
			HStack {
				Text("Global Nerdinary")
					.font(.largeTitle)
					.bold()
				
				Spacer()
			}
			.padding([.leading, .top])
			
			WordsListView(entries: $entries, loadMethod: loadGlobalWords)
		}
    }
	
	func loadGlobalWords() {
		//TODO: - Remove transport key from info.plist, not safe for app store
		print("Displaying global words")
		
		guard let url = URL(string: "http://127.0.0.1:5000/non_user_words/1002") else {
			print("Invalid URL")
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
						
					}

					// everything is good, so we can exit
					return
				} else {
					print("problem with decoded response")
				}
				
			} else {
				print("problem with data")
			}

			// if we're still here it means there was a problem
			print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
			//self.wordDoesntExistAlert = true
			print("Failed")
			
		}.resume()
	}
}

struct GlobalWordsView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalWordsView()
    }
}
