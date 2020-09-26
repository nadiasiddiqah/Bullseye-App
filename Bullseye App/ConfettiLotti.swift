//
//  ConfettiLotti.swift
//  Bullseye App
//
//  Created by Nadia Siddiqah on 9/23/20.
//  Copyright © 2020 Nadia Siddiqah. All rights reserved.
//

import SwiftUI

struct ConfettiLotti: View {
    var body: some View {
        VStack {
            LottieView(filename: "Confetti")
                .frame(width: 1000, height: 1000)
        }
    }
}

struct ConfettiLotti_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiLotti()
    }
}
