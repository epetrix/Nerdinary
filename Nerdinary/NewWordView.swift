//
//  NewWordView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/5/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct NewWordView: View {
	
	@State private var headWord: String = ""
	@State private var definitions = [String]()
	@State private var wordToSearch: String = ""
	@State private var results = [Entry]()
	
	@Binding var presenting: Bool
	@Binding var entries: [Entry]
	
	var body: some View {
		Text("Hello Word")
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
							self.results = decodedResponse

							self.headWord = self.results.first?.hwi.hw ?? "error"

							self.definitions = []
							for entry in self.results {
								self.definitions.append(entry.shortdef.first ?? "error")
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
}

struct NewWordView_Previews: PreviewProvider {
	
	@State static var present: Bool = true
	@State static var entries: [Entry] = []
	
    static var previews: some View {
		NewWordView(presenting: $present, entries: $entries)
    }
}
