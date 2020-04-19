//
//  QuizView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct QuizView: View {
	
//	@State var entries: [Entry] = [
//		Entry(headword: "Castrametation", shortdef: "Def", definitions: ["The science of setting up a camp"], functionalLabel: .noun),
//		Entry(headword: "Insectarium", shortdef: "Def", definitions: ["Museum of insects"], functionalLabel: .noun),
//		Entry(headword: "Entomologist", shortdef: "Def", definitions: ["Someone who studies insects"], functionalLabel: .noun),
//		Entry(headword: "Flutterby", shortdef: "Def", definitions: ["The opposite of a butterfly"], functionalLabel: .noun)
//	]
	
	@State var entries: [Entry] = [Entry]()
	@State var quizword: Entry = Entry(headword: "", shortdef: "", definitions: [], functionalLabel: .noun)
	@State var showAlert: Bool = false
	@State var answerCorrect: Bool = false
	@State var showingIndicator: Bool = false
	@State var selectedAnswer: Entry = Entry(headword: "", shortdef: "", definitions: [], functionalLabel: .noun)
	
	@State private var flipped = [false, false, false, false]
	
    var body: some View {
		GeometryReader { geometry in
			VStack {
				HStack {
					Text("Quiz")
					.font(.largeTitle)
					.bold()
					.foregroundColor(.white)
					
					if self.showingIndicator {
						ActivityIndicator()
						.frame(width: 32, height: 32)
					}
					
					Spacer()
				}
				.padding()
				
				Spacer()
				
				Text("What is the definition for \(self.quizword.headword)?")
					.frame(width: geometry.size.width)
					.font(.system(size: 24))
					.multilineTextAlignment(.center)
					.padding(.vertical, 30)
					.padding(.horizontal)
					.animation(.easeInOut)
				
				Spacer()
				
				VStack(spacing: 20) {
					
					ForEachWithIndex(self.entries, id: \.self) { index, item in
						QuizWordView(entry: item, correctFunc: self.checkCorrect, flipped: self.$flipped[index])
						.UseNiceShadow()
					}
					
					if self.answerCorrect {
						CorrectAnswerView(isPresented: self.$answerCorrect, replayFunc: self.loadFromDB)
					} else {
						Spacer().frame(height: 50)
					}
				}
				
				Spacer()
			}
			.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
			.animation(.easeInOut)
			.onAppear {
				self.loadFromDB()
			}
		}
    }
	
	func checkCorrect(answer: Entry) {
		if answer == quizword {
			withAnimation(.easeInOut) {
				answerCorrect = true //TODO: - Make any flipped cards unflip
			}
		}
		//showAlert = true
	}
	
	func loadFromDB() {
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
				
				print("JSON String:\n \(String(data: data, encoding: .utf8) ?? "error")")
				
				if let decodedResponse = try? JSONDecoder().decode([DBEntryIn].self, from: data) {
					
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
			
		}.resume()
	}
}

struct QuizView_Previews: PreviewProvider {
	
	static var entries: [Entry] = [
		Entry(headword: "Castrametation", shortdef: "Def", definitions: ["The science of setting up a camp"], functionalLabel: .noun),
		Entry(headword: "Insectarium", shortdef: "Def", definitions: ["Museum of insects"], functionalLabel: .noun),
		Entry(headword: "Entomologist", shortdef: "Def", definitions: ["Someone who studies insects"], functionalLabel: .noun),
		Entry(headword: "Flutterby", shortdef: "Def", definitions: ["The opposite of a butterfly"], functionalLabel: .noun)
	]
	
    static var previews: some View {
		QuizView(entries: entries)
    }
}
