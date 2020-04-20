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
	@State private var functionalLabel: String = ""
	@State private var wordToSearch: String = ""
	@State private var homographs = [DictEntry]()
	@State private var wordDoesntExistAlert: Bool = false
	
	var loadFunc: () -> ()
	
	@Binding var presenting: Bool
	//@Binding var entries: [DBEntry]
	
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
					UIApplication.shared.endEditing()
					self.loadDataFromDictionary()
				}) {
					WideButtonView(text: "Search", backgroundColor: Color("Color Scheme Orange"), foregroundColor: .white, cornerRadius: 4, systemFontSize: 20)
					.frame(width: 100)
				}
			}
			.padding(.leading)
			.padding(.trailing)
			.alert(isPresented: $wordDoesntExistAlert) {
				Alert(title: Text("Word doesn't exist"), message: Text("Please check your spelling and try again"), dismissButton: .default(Text("OK")))
			}
			
			List {
				ForEach(definitions, id: \.count) { def in
					Text(def)
				}
			}
			
			HStack {
				Button(action: {
					self.presenting = false
				}) {
					WideButtonView(text: "Cancel", backgroundColor: Color("Color Scheme Red"), foregroundColor: .white, cornerRadius: 4)
						.padding(.horizontal, 5)
				}
				
				Button(action: {
					self.saveToServer()
				}) {
					WideButtonView(text: "Save", backgroundColor: Color("Color Scheme Green"), foregroundColor: .white, cornerRadius: 4)
						.padding(.horizontal, 5)
				}
				.disabled(definitions.isEmpty)
			}
			.padding(.bottom)
		}
		.ableToEndEditing()
	}
	
	func loadDataFromDictionary() {
		let group = DispatchGroup()
		group.enter()
		
		guard let url = URL(string: "https://www.dictionaryapi.com/api/v3/references/collegiate/json/\(wordToSearch)?key=2c2558a4-f416-4d40-aa92-8a77137391d7") else {
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
	
	func saveToServer() {
		let group = DispatchGroup()
		group.enter()
		
		do {
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
			
			let entry = DBEntry(UID: uid, WRD: self.wordToSearch.firstUppercased, PD: definitions.first!, SD: definitions.count == 1 ? "" : definitions[1], TYP: functionalLabel.uppercased())
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = try JSONEncoder().encode(entry)
			
			//print(String(data: request.httpBody!, encoding: .utf8)!)
			
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
						return
					}
					
					else {
						DispatchQueue.main.async {
							print("Success: Response:\n\(dataString)")
							self.presenting = false
							self.loadFunc()
							group.leave()
						}
					}
				}
				
			}.resume()
		} catch {
			group.leave()
		}
	}
}

enum APIError: Error {
	case responseProblem
	case decodingProblem
	case encodingProblem
}

struct NewWordView_Previews: PreviewProvider {
	
	@State static var present: Bool = true
	@State static var entries: [DBEntry] = []
	static func function() {}
	
    static var previews: some View {
		NewWordView(loadFunc: function, presenting: $present)
    }
}
