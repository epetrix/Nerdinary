//
//  GlobalWordsVM.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 5/1/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

class GlobalWordsVM: ObservableObject {
	
	@Published var entries: [Entry] = [Entry]()
	
	func loadGlobalWords() {
		let group = DispatchGroup()
		group.enter()
		
		//TODO: - Remove transport key from info.plist, not safe for app store
		print("Displaying global words")
		
		let uid = UserDefaults.standard.integer(forKey: "userID")
		if uid == 0 {
			print("Invalid User ID")
			group.leave()
			return
		}
		
		guard let url = URL(string: "http://127.0.0.1:5000/non_user_words/\(uid)") else {
			print("Invalid URL")
			group.leave()
			return
		}
				
		let request = URLRequest(url: url)
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			// step 4
			
			if let data = data {
				
				//print("JSON String:\n \(String(data: data, encoding: .utf8) ?? "error")")
				
				if let decodedResponse = try? JSONDecoder().decode([DBEntry].self, from: data) {
					
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

