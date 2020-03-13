//
//  SwiftUIView.swift
//  Nerdinary
//
//  Created by Josh Jaslow on 3/10/20.
//  Copyright © 2020 Josh Jaslow. All rights reserved.
//

import SwiftUI

struct HostingView: View {
	
	@EnvironmentObject var viewRouter: ViewRouter
	
	@State var unlocked = false
	
    var body: some View {
        
		VStack {
			if viewRouter.currentPage == CurrentPage.login {
				LoginView()
			} else if viewRouter.currentPage == CurrentPage.main {
				DashBoard()
				.transition(.scale)
//				.transition(.move(edge: .trailing))
			}
		}
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HostingView().environmentObject(ViewRouter())
    }
}
