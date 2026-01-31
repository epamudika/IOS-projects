
//
//  ContentView.swift
//  ColorMtchingGame2
//
//  Created by COBSCCOMP242P-051 on 2026-01-17.
//



import SwiftUI

// MARK: - Screens
enum GameScreen {
    case home
    case instructions
    case game
}

// MARK: - Main Controller
struct ContentView: View {
    @State private var screen: GameScreen = .home

    var body: some View {
        switch screen {
        case .home:
            HomeView {
                screen = .instructions
            }
        case .instructions:
            InstructionView {
                screen = .game
            }
        case .game:
            GameView {
                screen = .home
            }
        }
    }
}

// MARK: - Home Screen
struct HomeView: View {
    var start: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("🎨 Mind Color Rush")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text("Think fast. Choose smart.")
                    .foregroundColor(.white.opacity(0.9))

                Button("Start") {
                    start()
                }
                .font(.title2.bold())
                .padding()
                .frame(width: 220)
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(15)
            }
        }
    }
}

// MARK: - Instruction Screen
struct InstructionView: View {
    var playGame: () -> Void

    var body: some View {
        VStack(spacing: 25) {
            Text("🧠 How to Play")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 15) {
                Text("• A color NAME will appear.")
                Text("• The text color may be misleading.")
                Text("• Tap the color that matches the WORD.")
                Text("• You have limited time ⏱️")
                Text("• Wrong answers or time up cost ❤️")
            }
            .font(.title3)

            Button("Play Game") {
                playGame()
            }
            .font(.title2.bold())
            .padding()
            .frame(width: 220)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
        .padding()
    }
}

// MARK: - Game Data
struct ColorItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
}

let gameColors: [ColorItem] = [
    .init(name: "Brown", color: .brown),
    .init(name: "Blue", color: .blue),
    .init(name: "Green", color: .green),
    .init(name: "Yellow", color: .yellow),
    .init(name: "Orange", color: .orange),
    .init(name: "Purple", color: .purple),
    .init(name: "Pink", color: .pink),
    .init(name: "Cyan", color: .cyan),
    .init(name: "Mint", color: .mint)
]

// MARK: - Game Screen
struct GameView: View {

    @State private var target: ColorItem = gameColors.randomElement()!
    @State private var misleadingColor: Color = .red

    @State private var score = 0
    @State private var level = 1
    @State private var hearts = 3

    @State private var timeLeft = 10
    @State private var timer: Timer?

    @State private var showGameOver = false
    @State private var showLevelWin = false
    @State private var showTimeUp = false

    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    var exitGame: () -> Void

    var body: some View {
        VStack(spacing: 15) {

            // Top Bar
            HStack {
                Text("Level \(level)")
                    .font(.title2.bold())

                Spacer()

                Text("⏱️ \(timeLeft)")
                    .font(.title2)
                    .foregroundColor(timeLeft <= 3 ? .red : .primary)

                Spacer()

                HStack {
                    ForEach(0..<hearts, id: \.self) { _ in
                        Text("❤️")
                    }
                }
            }
            .padding(.horizontal)

            Text("Score: \(score)")
                .font(.title3)

            // Target
            VStack(spacing: 10) {
                Text("Match the WORD")
                    .font(.headline)

                Text(target.name)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(misleadingColor)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)

            // Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(gameColors) { item in
                    Button {
                        checkAnswer(item)
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(item.color)
                            .frame(height: 80)
                            .shadow(radius: 4)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            startRound()
        }
        .onDisappear {
            timer?.invalidate()
        }

        // Time Up Alert
        .alert("⏰ Time's Up!", isPresented: $showTimeUp) {
            Button("Restart") {
                restartGame()
            }
            Button("Home") {
                exitGame()
            }
        } message: {
            Text("Your time is up.\nDo you want to restart the game?")
        }

        // Game Over Alert
        .alert("Game Over", isPresented: $showGameOver) {
            Button("Restart") {
                restartGame()
            }
            Button("Home") {
                exitGame()
            }
        }

        // Level Complete Alert
        .alert("Level Complete!", isPresented: $showLevelWin) {
            Button(level == 5 ? "Finish" : "Next Level") {
                nextLevel()
            }
        }
    }

    // MARK: - Game Logic

    func startRound() {
        target = gameColors.randomElement()!
        misleadingColor = gameColors.filter { $0.color != target.color }.randomElement()!.color
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timeLeft = max(5, 10 - level)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeLeft -= 1
            if timeLeft <= 0 {
                timer?.invalidate()
                showTimeUp = true
            }
        }
    }

    func checkAnswer(_ item: ColorItem) {
        timer?.invalidate()

        if item == target {
            score += 1
            if score >= level * 4 {
                showLevelWin = true
            } else {
                startRound()
            }
        } else {
            wrongAnswer()
        }
    }

    func wrongAnswer() {
        hearts -= 1
        if hearts == 0 {
            showGameOver = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startRound()
            }
        }
    }

    func nextLevel() {
        if level < 5 {
            level += 1
            score = 0
            hearts = 3
            startRound()
        } else {
            exitGame()
        }
    }

    func restartGame() {
        timer?.invalidate()
        level = 1
        score = 0
        hearts = 3
        startRound()
    }
}
