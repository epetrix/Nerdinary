//
//  ViewRouter.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/12/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI
import Combine

class ViewRouter: ObservableObject {
	
	let objectWillChange = PassthroughSubject<ViewRouter,Never>()
	
	var currentPage: CurrentPage = .login {
        didSet {
			withAnimation() {
				objectWillChange.send(self)
			}
        }
    }
    
}

enum CurrentPage {
	case login, main
}
