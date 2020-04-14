//
//  QuizView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct QuizView: View {
	
	@State var entries: [Entry] = [
		Entry(headword: "Castrametation", shortdef: "Def", definitions: ["The science of setting up a camp"], functionalLabel: .noun),
		Entry(headword: "Insectarium", shortdef: "Def", definitions: ["Museum of insects"], functionalLabel: .noun),
		Entry(headword: "Entomologist", shortdef: "Def", definitions: ["Someone who studies insects"], functionalLabel: .noun),
		Entry(headword: "Flutterby", shortdef: "Def", definitions: ["The opposite of a butterfly"], functionalLabel: .noun)
	]
	
	//@State var entries: [Entry] = [Entry]()
	@State var quizword: Entry = Entry(headword: "", shortdef: "", definitions: [], functionalLabel: .noun)
	@State var showAlert: Bool = false
	@State var selectedAnswer: Entry = Entry(headword: "", shortdef: "", definitions: [], functionalLabel: .noun)
	
	var alertTitle: String {
		return quizword == selectedAnswer ? "Correct!": "Incorrect"
	}
	var alertMessage: String {
		if quizword != selectedAnswer {
			return "\(selectedAnswer.definitions.first!) is the definition for \(selectedAnswer.headword)"
		} else {
			return ""
		}
	}
	var buttonTitle: String {
		return quizword == selectedAnswer ? "Play Again": "Try Again"
	}
	
    var body: some View {
		VStack {
			HStack {
				Text("Quiz")
				.font(.system(size: 32, weight: .bold))
				
				Spacer()
			}
			.padding()
			
			Spacer()
			
			Text("What is the definition for \(quizword.headword)?")
				.font(.system(size: 24))
				.multilineTextAlignment(.center)
				.padding(.vertical, 30)
				.padding(.horizontal)
			
			Spacer()
			
			VStack(spacing: 20) {
				QuizWordView(entry: entries[0], correctFunc: checkCorrect)
				QuizWordView(entry: entries[1], correctFunc: checkCorrect)
				QuizWordView(entry: entries[2], correctFunc: checkCorrect)
				QuizWordView(entry: entries[3], correctFunc: checkCorrect)
			}
			.alert(isPresented: $showAlert) {
				Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text(buttonTitle), action: {
					if self.alertTitle == "Correct!" {
						self.loadFromDB()
					}
					
				}))
			}
			
			Spacer()
		}
		.onAppear {
			self.loadFromDB()
		}
    }
	
	func checkCorrect(answer: Entry) {
		self.selectedAnswer = answer
		showAlert = true
	}
	
	func loadFromDB() {
		//call loading code, load words into entries
		let randomInt = Int.random(in: 0..<4)
		quizword = entries[randomInt]
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