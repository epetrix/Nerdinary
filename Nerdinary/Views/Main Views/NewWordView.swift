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
					self.loadData()
				}) {
					WideButtonView(text: "Search", backgroundColor: .blue, cornerRadius: 4, systemFontSize: 20)
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
					WideButtonView(text: "Cancel", backgroundColor: .red, cornerRadius: 4)
						.padding(.horizontal, 5)
				}
				
				Button(action: {
					self.presenting = false
					self.saveToServer() { success in
						
					}
				}) {
					WideButtonView(text: "Save", cornerRadius: 4)
						.padding(.horizontal, 5)
				}
			}
		}
		.ableToEndEditing()
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
					
					if let decodedResponse = try? JSONDecoder().decode([DictEntry].self, from: data) {
						
						// we have good data – go back to the main thread
						DispatchQueue.main.async {
	//						 update our UI
							self.homographs = decodedResponse

							self.headWord = self.homographs.first?.hwi.hw ?? "error"
							
							self.functionalLabel = self.homographs.first!.fl.uppercased()

							self.definitions = []
							for entry in self.homographs {
								let firstShortDef = entry.shortdef.first ?? "error"
//								self.definitions.append("\(partOfSpeech): \(firstShortDef)")
								self.definitions.append("\(firstShortDef)")
							}
							
						}

						// everything is good, so we can exit
						return
					} else {}
				} else {}

				// if we're still here it means there was a problem
				print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
				self.wordDoesntExistAlert = true
				
			}.resume()
		}
	
	func saveToServer(completion: @escaping(Result<Data, APIError>) -> Void) {
		do {
			guard let url = URL(string: "http://127.0.0.1:5000/user/user_word") else {
				print("Invalid URL")
				return
			}
			
			guard !definitions.isEmpty else { return }
			
			let entry = DBEntryOut(UID: "1002", WRD: headWord, PD: definitions.first!, SD: definitions[1], TYP: functionalLabel.uppercased())
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = try JSONEncoder().encode(entry)
			
			print(request.description)
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				
				guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
					completion(.failure(.responseProblem))
					return
				}
				
				DispatchQueue.main.async {
					print(jsonData)
					completion(.success(jsonData))
				}
				
			}.resume()
		} catch {
			completion(.failure(.encodingProblem))
		}
		
		self.loadFunc()
	}
}

enum APIError: Error {
	case responseProblem
	case decodingProblem
	case encodingProblem
}

struct NewWordView_Previews: PreviewProvider {
	
	@State static var present: Bool = true
	@State static var entries: [DBEntryOut] = []
	static func function() {}
	
    static var previews: some View {
		NewWordView(loadFunc: function, presenting: $present)
    }
}
