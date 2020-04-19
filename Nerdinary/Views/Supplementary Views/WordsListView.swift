//
//  WordsListView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/15/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct WordsListView: View {
	
	@Binding var entries: [Entry]
	var loadMethod: () -> ()
	var isGlobal: Bool = false
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView(.vertical, showsIndicators: false) {
				ForEach(self.entries, id: \.id) { entry in
					DynamicWordView(isGlobal: self.isGlobal, entry: entry, deleteFunc: self.deleteEntry)
					.modifier(ListRowModifier())
					.animation(.easeInOut(duration: 0.3))
					//scroll down if area becomes larger when opening a word
				}
				.frame(width: geometry.size.width)
			}
//			.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom))
			.onAppear(perform: self.loadMethod)
		}
	}
	
	func deleteEntry(entry: Entry) {
		let group = DispatchGroup()
		group.enter()
		
		print("Deleting entry: \(entry.headword)")
		
		guard let url = URL(string: "http://127.0.0.1:5000/user_word") else {
			print("Invalid URL")
			group.leave()
			return
		}
		
		let uid = UserDefaults.standard.integer(forKey: "userID")
		if uid == 0 {
			print("Invalid User ID")
			group.leave()
			return
		}
		
		let wordToDelete = DBDeleteWord(UID: uid, WRD: entry.headword)
		guard let encodedEntry = try? JSONEncoder().encode(wordToDelete) else {
			print("Failed to encode word to delete")
			group.leave()
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = encodedEntry
		
		//print(String(data: request.httpBody!, encoding: .utf8)!)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if let error = error {
				print("Error occurred: \(error)")
				group.leave()
				return
			}
			
			if let data = data, let dataString = String(data: data, encoding: .utf8), let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode != 202 {
					print("Error code: \(httpResponse.statusCode)")
					print("Response:\n\(dataString)")
					group.leave()
					return
				}
				
				else {
					DispatchQueue.main.async {
						print("Response:\n\(dataString)")
						self.loadMethod()
						group.leave()
					}
				}
			}
			
		}.resume()
	}
}

struct WordsListView_Previews: PreviewProvider {
	
	@State static var entries: [Entry] = [Entry(headword: "Word", shortdef: "Definition", definitions: ["Def1", "Def2"], functionalLabel: fl.noun)]
	
    static var previews: some View {
		WordsListView(entries: $entries, loadMethod: testFunc)
    }
	
	static func testFunc() {
		
	}
}
