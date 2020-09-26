//
//  AboutView.swift
//  Bullseye App
//
//  Created by Nadia Siddiqah on 9/22/20.
//  Copyright © 2020 Nadia Siddiqah. All rights reserved.
//

import SwiftUI

// ABOUT VIEW OBJECT
struct AboutView: View {
    
    // CONSTANTS
    let beige = Color(red: 1.0, green: 0.84, blue: 0.70)
    
    // USER INTERFACE CONTENT + LAYOUT
    var body: some View {
        Group {     /// Group (view) = groups views together + expands to fill view which contains it (full screen)
            VStack {
                Text("🎯 Bullseye 🎯")     // control+command+space for emojis
                    .modifier(AboutHeadingStyle())
                    .navigationBarTitle("About Bullseye")       // sets Text for NavBar
                Text("This is Bullseye, the game where you can win points and earn fame by dragging a slider.")
                    .modifier(AboutBodyStyle())
                Text("Your goal is to place the slider as close as possible to the target value. The closer you are, the more points you score.")
                    .modifier(AboutBodyStyle())
                Text("Enjoy the game!")
                    .modifier(AboutBodyStyle())
            }
            .background(beige)
        }
        .background(Image("Background"))
    }
}

// VIEW MODIFIERS
// ==============
struct AboutHeadingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 30))
            .foregroundColor(Color.black)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
}

struct AboutBodyStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 16))
            .foregroundColor(Color.black)
            .padding(.leading, 60)
            .padding(.trailing, 60)
            .padding(.bottom, 20)
            .lineLimit(nil)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
