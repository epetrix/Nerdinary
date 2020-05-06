//
//  QuizVM.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 5/6/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

class QuizVM: ObservableObject {
	@Published var entries: [Entry] = [Entry]()
	@Published var quizword: Entry = Entry(headword: "", shortdef: "", definitions: [], functionalLabel: .noun)
	@Published var showAlert: Bool = false
	@Published var answerCorrect: Bool = false
	@Published var showingIndicator: Bool = false
	@Published var selectedAnswer: Entry = Entry(headword: "", shortdef: "", definitions: [], functionalLabel: .noun)
	
	@Published var flipped = [false, false, false, false]
	
	func checkCorrect(answer: Entry) {
		if answer == quizword {
			withAnimation(.easeInOut) {
				answerCorrect = true //TODO: - Make any flipped cards unflip
			}
		}
		//showAlert = true
	}
	
	func loadFromDB() {
		#if DEBUG
		showingIndicator = true
		for n in 0..<4 {
			self.flipped[n] = false
		}
		
		let randomInt = Int.random(in: 0..<4)
		self.quizword = self.entries[randomInt]
		
		self.showingIndicator = false
		#endif
		
		let group = DispatchGroup()
		group.enter()
		
		//call loading code, load words into entries
		showingIndicator = true
		
		//TODO: - Remove transport key from info.plist, not safe for app store
		print("Getting quiz words")
		
		let uid = UserDefaults.standard.integer(forKey: "userID")
		if uid == 0 {
			print("Invalid User ID")
			group.leave()
			return
		}
		
		guard let url = URL(string: "http://127.0.0.1:5000/non_user_rand_4_words/\(uid)") else {
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
						
						for n in 0..<4 {
							self.flipped[n] = false
						}
						self.entries.removeAll()
						
						for entry in decodedResponse {
							self.entries.append(Entry(e: entry))
						}
						
						let randomInt = Int.random(in: 0..<4)
						self.quizword = self.entries[randomInt]
						
						self.showingIndicator = false
						
						group.leave()
					}

					// everything is good, so we can exit
					return
				} else {
					group.leave()
				}
				
			} else {
				group.leave()
			}

			// if we're still here it means there was a problem
			print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
			//self.wordDoesntExistAlert = true
			print("Failed")
			self.showingIndicator = false
			
		}.resume()
	}
}

//For previews
extension QuizVM {
	func addTestEntries(_ entries: [Entry]) -> QuizVM {
		self.entries = entries
		return self
	}
}
