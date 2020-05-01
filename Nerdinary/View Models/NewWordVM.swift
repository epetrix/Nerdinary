//
//  NewWordVM.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 5/1/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

class NewWordVM: ObservableObject {
	
	@Published var headWord: String = "Search for a New Word"
	@Published var definitions = [String]()
	@Published var functionalLabel: String = ""
	@Published var wordToSearch: String = ""
	@Published var homographs = [DictEntry]()
	@Published var wordDoesntExistAlert: Bool = false
	@Published var showingIndicator: Bool = false
	
	@ObservedObject var localVM: LocalWordsVM
	
	init(vm: LocalWordsVM) {
		self.localVM = vm
	}
	
	func loadDataFromDictionary() {
		let group = DispatchGroup()
		group.enter()
		
		let word = wordToSearch.trimmingCharacters(in: .whitespaces)
		
		guard word != "", let url = URL(string: "https://www.dictionaryapi.com/api/v3/references/collegiate/json/\(word)?key=2c2558a4-f416-4d40-aa92-8a77137391d7") else {
			print("Invalid URL")
			group.leave()
			return
		}
		
		let request = URLRequest(url: url)
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			// step 4
			
			if let data = data {
				//print("JSON String: \(String(data: data, encoding: .utf8) ?? "error")")
				
				if let decodedResponse = try? JSONDecoder().decode([DictEntry].self, from: data) {
					
					// we have good data – go back to the main thread
					DispatchQueue.main.async {
//						 update our UI
						self.homographs = decodedResponse

						self.headWord = self.homographs.first?.hwi.hw ?? "error"
						
						self.functionalLabel = self.homographs.first!.fl.uppercased()

						self.definitions.removeAll()
						
						for entry in self.homographs {
							let firstShortDef = entry.shortdef.first ?? "error"
							self.definitions.append("\(firstShortDef)")
						}
						
						group.leave()
					}

					// everything is good, so we can exit
					return
				} else {
					group.leave()
					print("problem here")
				}
			} else {
				group.leave()
				print("problem here")
			}

			// if we're still here it means there was a problem
			print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
			self.wordDoesntExistAlert = true
			
		}.resume()
	}
	
	func loadFromNewDictionary() {
		let group = DispatchGroup()
		group.enter()
		
		let word = wordToSearch.trimmingCharacters(in: .whitespaces).lowercased()
		
		let endpoint = "entries"
		let language = "en-us"
		
		guard word != "", let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v2/\(endpoint)/\(language)/\(word)") else {
			print("Invalid URL")
			group.leave()
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("50fd04cc", forHTTPHeaderField: "app_id")
		request.addValue("07ede523c1fee0e72b747455c3d89faa", forHTTPHeaderField: "app_key")
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			// step 4
			
			if let data = data {
				//print("JSON String: \(String(data: data, encoding: .utf8) ?? "error")")
				
				if let decodedResponse = try? JSONDecoder().decode([DictEntry].self, from: data) {
					
					// we have good data – go back to the main thread
					DispatchQueue.main.async {
//						 update our UI
						self.homographs = decodedResponse

						self.headWord = self.homographs.first?.hwi.hw ?? "error"
						
						self.functionalLabel = self.homographs.first!.fl.uppercased()

						self.definitions.removeAll()
						
						for entry in self.homographs {
							let firstShortDef = entry.shortdef.first ?? "error"
							self.definitions.append("\(firstShortDef)")
						}
						
						group.leave()
					}

					// everything is good, so we can exit
					return
				} else {
					group.leave()
					print("problem here")
				}
			} else {
				group.leave()
				print("problem here")
			}

			// if we're still here it means there was a problem
			print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
			self.wordDoesntExistAlert = true
			
		}.resume()
	}
	
	func saveToServer() {
		let group = DispatchGroup()
		group.enter()
		
		showingIndicator = true
		
		guard let url = URL(string: "http://127.0.0.1:5000/user_word") else {
			print("Invalid URL")
			group.leave()
			return
		}
		
		guard !definitions.isEmpty else {
			print("Definitions are empty")
			group.leave()
			return
		}
		
		let uid = UserDefaults.standard.integer(forKey: "userID")
		if uid == 0 {
			print("Invalid User ID")
			group.leave()
			return
		}
		
		let entry = DBEntry(UID: uid, WRD: self.wordToSearch.firstUppercased, PD: definitions.first!.firstUppercased, SD: definitions.count == 1 ? "" : definitions[1].firstUppercased, TYP: functionalLabel.uppercased())
		guard let encodedEntry = try? JSONEncoder().encode(entry) else {
			print("Failed to encode word to delete")
			group.leave()
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = encodedEntry
		
		print(String(data: request.httpBody!, encoding: .utf8)!)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if let error = error {
				print("Error occurred: \(error)")
				group.leave()
				return
			}
			
			if let data = data, let dataString = String(data: data, encoding: .utf8), let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode != 201 {
					print("Error code: \(httpResponse.statusCode)")
					print("Response:\n\(dataString)")
					group.leave()
					self.showingIndicator = false
					return
				}
				
				else {
					DispatchQueue.main.async {
						//print("Success: Response:\n\(dataString)")
						self.localVM.presentNewWordView = false
//						self.loadFunc()
						self.localVM.loadLocalWords()
						self.showingIndicator = false
						group.leave()
					}
				}
			}
			
		}.resume()
	}
}
