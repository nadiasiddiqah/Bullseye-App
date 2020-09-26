//
//  ContentView.swift
//  Bullseye App
//
//  Created by Nadia Siddiqah on 9/11/20.
//  Copyright © 2020 Nadia Siddiqah. All rights reserved.
//

// SwiftUI = used to make user interaces + respond to user actions
import SwiftUI

// ContentView Object (reps app's main screen / View = property)
struct ContentView: View {

    // PROPERTIES
    // ==========
    
    // COLORS
    let midnightBlue = Color(red: 0, green: 0.2, blue: 0.4)
    
    // GAME STATS
    @State var score = 0
    @State var round = 1
    @State var isBullseye = false
    
    // USER INTERFACE VIEWS
        ///@State var = marks var as part of app's state --> swift looks for changes in its value (bc it affects objects in the app)
    @State var alertIsVisible = false                /// hides alert
    @State var sliderValue = 50.0                    /// sets sliderValue + stores changes based on Slider view
//    @State var target = 1
    @State var target = Int.random(in: 1...100)     /// inclusive (1-100) // half-opened (1-99): 1..<100
                                                   /// generates new random target value everytime app start

    // Rounded sliderValue (computed property, var-func hybrid, always declare data type)
    var sliderValueRounded: Int {
        return Int(sliderValue.rounded())     /// uses rounded() method of Double data type
    }
    
    var sliderTargetDifference: Int {
        abs(sliderValueRounded - target)
    }
    
    // USER INTERFACE CONTENT & LAYOUT (body = property / container for ContentView objects)
    var body: some View {
        NavigationView {
            VStack {
                Spacer().navigationBarTitle("🎯 Bullseye 🎯")   // sets Text for NavBar
                    // call navigationBarTitle method in any view object
                
                // TARGET ROW
                HStack {
                    Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                    Text("\(target)").modifier(ValueStyle())      /// object.feature form -> object = ContentView/self + feature = target
                }
                
                Spacer()
                
                // SLIDER ROW
                HStack {
                    Text("1").modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 1...100)   /// Two-way binding btwn Slider object + sliderValue var
                        .accentColor(Color.green)
                        .animation(.easeOut)        // animation to make slider slide to random position
                    Text("100").modifier(LabelStyle())
                }
                
                Spacer()
                
                // ZStack holds the ConfettiLotti View (visible if isBullseye = true determined by bullseyeConfetti() method)
                ZStack {
                    // BUTTON ROW
                    Button(action: {
                        // Delays execution btwn the two code statements
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            bullseyeConfetti()      // checks if Bullseye is hit
                            self.alertIsVisible = true      // shows alert pop-up
                        }
                    }) {
                        Text("Hit me!").modifier(ButtonLargeTextStyle())
                    }
                    .background(Image("Button")).modifier(Shadow())
                    .alert(isPresented: $alertIsVisible) {
                        Alert(title: Text(alertTitle()),
                              message: Text(scoringMessage()),
                              dismissButton: .default(Text("Awesome!")) {
                                self.startNewRound()
                                self.isBullseye = false     // hides ConfettiLotti View
                            })
                    }
                }
                if isBullseye {
                    ConfettiLotti()
                }
          
                Spacer()
                        
                // SCORE ROW
                HStack {
                    Button(action: {
                        self.startNewGame()
                    }) {
                        HStack {
                            Image("StartOverIcon")
                            Text("Start Over").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button")).modifier(Shadow())
                    
                    Spacer()
                    
                    Text("Score:").modifier(LabelStyle())
                    Text("\(score)").modifier(ValueStyle())
                    
                    Spacer()
                    
                    Text("Round:").modifier(LabelStyle())
                    Text("\(round)").modifier(ValueStyle())
                    
                    Spacer()
                    
                    // Change from button to NavigationLink (to destination view)
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button")).modifier(Shadow())
                }
                .padding(.bottom, 20)
                .accentColor(midnightBlue)      // change icon colors to midnight blue
            }
            // body view object's -> onAppear method (executes code when view appears)
            .onAppear() {
                self.startNewGame()     // randomizes sliderValue when game first starts up (instead of default 50.0)
        }
        .background(Image("Background"))    //use VStack's background method to create image view of "Background"
    }
    .navigationViewStyle(StackNavigationViewStyle())
}
    
    // METHODS
    // ======= (use self inference - "self" isn't required within an object's properties/methods)
    
    // Method: calculate the points for the current round
    func pointsForCurrentRound() -> Int {
      let maximumScore: Int = 100
      
      let points: Int
      if sliderTargetDifference == 0 {
        points = 200
      } else if sliderTargetDifference == 1 {
        points = 150
      } else {
        points = maximumScore - sliderTargetDifference
      }
      return points
    }
    
    // Method: simplify alert pop-up code (its msg parameter)
    func scoringMessage() -> String {
        return "The slider's value is \(sliderValueRounded).\n" +
               "The target value is \(target).\n" +
               "You scored \(pointsForCurrentRound()) points this round."
    }
    
    // Method: update alert title based on how well the player did
    func alertTitle() -> String {
      let title: String
      if sliderTargetDifference == 0 {
        title = "Bullseye!"
      } else if sliderTargetDifference < 5 {
        title = "So close!"
      } else if sliderTargetDifference < 10 {
        title = "Not bad."
      } else {
        title = "Are you even trying bro?"
      }
      return title
    }
    
    // Method: restart game / reset values (called when player dismisses pop-up)
    func startNewGame() {
        score = 0
        round = 1
        resetSliderAndTarget()
    }
    
    // Method: start new round / set new round values (called when player presses Start over button)
    func startNewRound() {
        /// update score, round, target/slider values (move from alert object to a func to declutter body var)
        score += pointsForCurrentRound()
        round += 1
        resetSliderAndTarget()
    }
    
    // Method: DRY up replicate lines in startNewGame() and startNewRound()
    func resetSliderAndTarget() {
        sliderValue = Double.random(in: 1...100)
        target = Int.random(in: 1...100)
//        target = 1
    }
    
    // Method: to test if bullseye was hit / if confetti should be released 
    func bullseyeConfetti() {
        if sliderTargetDifference == 0 {
            self.isBullseye = true
        }
    }

// VIEW MODIFIERS
// ============== creates packages of methods to be adopted by objects in different parts of the UI

// LabelStyle ViewModifier Protocol (used to style label views in CotentView's body property)
struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {      // uses body method to accept "Content" of body view
        content     // methods used to modify the content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.white)
            .modifier(Shadow())
    }
}

// ValueStyle ViewModifier Protocol (used to style value views in CotentView's body property)
struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
    }
}

// Shadow ViewModifier Protocol (used to style value views in CotentView's body property)
struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

// Large Button ViewModifier Protocol (used to create button with larger text)
struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.black)
    }
}
    
// Small Button ViewModifier Protocol (used to create button with smaller text)
struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
            .foregroundColor(Color.black)
    }
}




// PREVIEW
// =======
    
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif


}
