//
//  WideButtonView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/30/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct WideButtonView: View {
	
	var text: String = "Custom Text"
	var backgroundColor: Color = .green
	var foregroundColor: Color = .white
	var cornerRadius: CGFloat = 15
	var systemFontSize: CGFloat = 24
	
	var body: some View {
		HStack {
			Spacer()

			Text(text)
				.foregroundColor(self.foregroundColor)
			.font(.system(size: self.systemFontSize))
			.padding([.top, .bottom], 5)

			Spacer()
		}
		.background(self.backgroundColor)
		.cornerRadius(self.cornerRadius)
	}
}

struct WideButtonView_Previews: PreviewProvider {
    static var previews: some View {
        WideButtonView()
    }
}
