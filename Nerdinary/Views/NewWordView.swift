//
//  NewWordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct NewWordView: View {
	
	@State private var headWord: String = "Search for a New Word"
	@State private var definitions = [String]()
	@State private var wordToSearch: String = ""
	@State private var homographs = [Entry]()
	
	@Binding var presenting: Bool
	@Binding var entries: [Entry]
	
	var body: some View {
		VStack {
			Text(headWord)
				.font(.system(size: 32))
				.padding(.top)
			
			HStack {
				TextField("Enter for Word", text: $wordToSearch)
				.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding(.trailing)
				
				Button(action: {
					self.loadData()
				}) {
					HStack {
						Spacer()

						Text("Search")
						.foregroundColor(.white)
						.font(.system(size: 24))
							.padding(.top, 5)
							.padding(.bottom, 5)

						Spacer()
					}
					.frame(width: 100)
					.background(Color.blue)
					.cornerRadius(4)
					
				}
			}
			.padding(.leading)
			.padding(.trailing)
			
			List(definitions, id: \.count) { def in
				Text(def)
			}
			
			HStack {
				Button(action: {
					self.presenting = false
				}) {
					HStack {
						Spacer()

						Text("Cancel")
						.foregroundColor(.white)
						.font(.system(size: 24))
							.padding(.top, 5)
							.padding(.bottom, 5)

						Spacer()
					}
					.background(Color.red)
					.cornerRadius(4)
					.padding(.leading)
					.padding(.trailing, 5)
				}
				
				Button(action: {
					self.presenting = false
					self.saveToServer()
				}) {
					HStack {
						Spacer()

						Text("Save")
						.foregroundColor(.white)
						.font(.system(size: 24))
							.padding(.top, 5)
							.padding(.bottom, 5)

						Spacer()
					}
					.background(Color.green)
					.cornerRadius(4)
					.padding(.leading, 5)
					.padding(.trailing)
				}
			}
		}
	}
	
	func loadData() {
			guard let url = URL(string: "https://www.dictionaryapi.com/api/v3/references/collegiate/json/\(wordToSearch)?key=2c2558a4-f416-4d40-aa92-8a77137391d7") else {
				print("Invalid URL")
				return
			}
			
			let request = URLRequest(url: url)
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				// step 4
				
				if let data = data {
					//print("JSON String: \(String(data: data, encoding: .utf8) ?? "error")")
					
					if let decodedResponse = try? JSONDecoder().decode([Entry].self, from: data) {
						
						// we have good data – go back to the main thread
						DispatchQueue.main.async {
	//						 update our UI
							self.homographs = decodedResponse

							self.headWord = self.homographs.first?.hwi.hw ?? "error"

							self.definitions = []
							for entry in self.homographs {
								let partOfSpeech = entry.fl
								let firstShortDef = entry.shortdef.first ?? "error"
								self.definitions.append("\(partOfSpeech): \(firstShortDef)")
							}
							
						}

						// everything is good, so we can exit
						return
					} else {}
				} else {}

				// if we're still here it means there was a problem
				print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
			}.resume()
		}
	
	func saveToServer() {
		
	}
}

struct NewWordView_Previews: PreviewProvider {
	
	@State static var present: Bool = true
	@State static var entries: [Entry] = []
	
    static var previews: some View {
		NewWordView(presenting: $present, entries: $entries)
    }
}
