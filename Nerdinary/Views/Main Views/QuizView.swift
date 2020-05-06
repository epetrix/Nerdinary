//
//  QuizView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 4/13/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct QuizView: View {
	
	@ObservedObject var quizVM: QuizVM = QuizVM()
	
    var body: some View {
		GeometryReader { geometry in
			VStack {
				HStack {
					Text("Quiz")
					.font(.largeTitle)
					.bold()
					.foregroundColor(.white)
					
					if self.quizVM.showingIndicator {
						ActivityIndicator()
						.frame(width: 32, height: 32)
					}
					
					Spacer()
				}
				.padding()
				
				Spacer()
				
				Text("What is the definition for \(self.quizVM.quizword.headword)?")
					.font(.system(size: 24))
					.multilineTextAlignment(.center)
					.padding(.vertical, 30)
					.padding(.horizontal)
					.animation(.easeInOut)
				
				Spacer()
				
				VStack(spacing: 20) {
					
					ForEachWithIndex(self.quizVM.entries, id: \.self) { index, item in
						QuizWordView(entry: item, correctFunc: self.quizVM.checkCorrect, flipped: self.$quizVM.flipped[index])
						.UseNiceShadow()
					}
					
					if self.quizVM.answerCorrect {
						CorrectAnswerView(isPresented: self.$quizVM.answerCorrect, replayFunc: self.quizVM.loadFromDB)
					} else {
						Spacer().frame(height: 50)
					}
				}
				
				Spacer()
			}
			.background(LinearGradient(gradient: Gradient(colors: [Color("Color Scheme Orange"), Color("Color Scheme Red")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
			.animation(.easeInOut)
			.onAppear {
				self.quizVM.loadFromDB()
			}
		}
    }
}

struct QuizView_Previews: PreviewProvider {
	
	static var entries: [Entry] = [
		Entry(headword: "Castrametation", shortdef: "Def", definitions: ["The science of setting up a camp"], functionalLabel: .noun),
		Entry(headword: "Insectarium", shortdef: "Def", definitions: ["Museum of insects"], functionalLabel: .noun),
		Entry(headword: "Entomologist", shortdef: "Def", definitions: ["Someone who studies insects"], functionalLabel: .noun),
		Entry(headword: "Flutterby", shortdef: "Def", definitions: ["The opposite of a butterfly"], functionalLabel: .noun)
	]
	
	static var qvm = QuizVM()
	
    static var previews: some View {
		QuizView(quizVM: qvm.addTestEntries(entries))
    }
}
