import SwiftUI

struct Flag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
    }
}

extension View {
    func flagStyle() -> some View {
        modifier(Flag())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var scoreMessage = ""
    @State private var reset = false
    @State private var round = 0
    @State private var animationDegrees = [0.0, 0.0, 0.0]
    @State private var wrongTapped:Int? = nil
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.4), location: 0.3),
                .init(color: Color(red: 0.0, green: 0.0, blue:0.2), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(Color.white)
            
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap on the flag of")
                            .foregroundStyle(Color.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(Color.black)
                            .font(.largeTitle.weight(.bold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            if number == correctAnswer {
                                withAnimation(.spring(duration: 1, bounce: 0.5)) {
                                    animationDegrees[number] = 360
                                }
                                FlagTapped(number)
                            } else {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        wrongTapped = number
                                    }
                                    FlagTapped(number)

                                }
                            }
                        label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 10)
                                .rotation3DEffect(
                                    .degrees(animationDegrees[number]), axis: (x: 0, y: 1, z: 0))
                                .opacity(wrongTapped == number ? 0.25 : 1.0)
                                .scaleEffect(wrongTapped == number ? 0.8 : 1.0)
                                
                        }
                        

                    } .alert(scoreTitle, isPresented: $showingScore) {
                        Button("Continue", action: askQuestion)
                    } message: {
                        Text(scoreMessage)
                    } .alert("The game ended. Your score: \(score)", isPresented: $reset) {
                        Button("Restart game", action: resetGame)
                    }
                }
                .flagStyle()
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(Color.white)
                    .font(.title.bold())
                
                Spacer()

            }
            .padding()
        }
    }
    
    func FlagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            scoreMessage = "Your score is \(score)."
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[number])."
        }
        showingScore = true
        round += 1
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationDegrees = [0.0, 0.0, 0.0]
        wrongTapped = nil
        if round == 8 {
            showingScore = false
            reset = true
            round = 0
        }
    }
    
    func resetGame() {
        score = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}

