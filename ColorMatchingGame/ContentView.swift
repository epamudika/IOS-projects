
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
    case game
}

// MARK: - Main Controller
struct ContentView: View {
    @State private var screen: GameScreen = .home

    var body: some View {
        switch screen {
        case .home:
            HomeView {
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
    var startGame: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text("🎨 Color Matching Game")
                .font(.largeTitle)
                .bold()

            Button("Start Game") {
                startGame()
            }
            .font(.title2)
            .padding()
            .frame(width: 200)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

// MARK: - Game Data
let gameColors: [Color] = [
    .brown, .blue, .green,
    .yellow, .orange, .purple,
    .pink, .cyan, .mint
]

// MARK: - Game Screen
struct GameView: View {

    @State private var targetColor: Color = .red
    @State private var score = 0
    @State private var level = 1
    @State private var hearts = 3
    @State private var showBomb = false

    @State private var showGameOver = false
    @State private var showLevelWin = false

    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)

    var exitGame: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            // Top Bar
            HStack {
                Text("Level \(level)")
                    .font(.title2)
                Spacer()
                HStack {
                    ForEach(0..<hearts, id: \.self) { _ in
                        Text("❤️")
                    }
                }
            }
            .padding(.horizontal)

            Text("Score: \(score)")
                .font(.title2)

            // Target Color
            Rectangle()
                .fill(targetColor)
                .frame(width: 140, height: 140)
                .cornerRadius(12)

            // Bomb Effect
            if showBomb {
                Text("💣")
                    .font(.system(size: 80))
            }

            // Color Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(gameColors, id: \.self) { color in
                    Button {
                        checkAnswer(color)
                    } label: {
                        Rectangle()
                            .fill(color)
                            .frame(height: 80)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            newRound()
        }
        .alert("Game Over", isPresented: $showGameOver) {
            Button("Restart") {
                restartGame()
            }
            Button("Home") {
                exitGame()
            }
        }
        .alert("Level Completed!", isPresented: $showLevelWin) {
            Button(level == 5 ? "Finish" : "Next Level") {
                nextLevel()
            }
        }
    }

    // MARK: - Game Logic

    func newRound() {
        targetColor = gameColors.randomElement()!
        showBomb = false
    }

    func checkAnswer(_ color: Color) {
        if color == targetColor {
            score += 1

            // Win condition per level
            if score >= level * 3 {
                showLevelWin = true
            } else {
                newRound()
            }
        } else {
            hearts -= 1
            showBomb = true

            if hearts == 0 {
                showGameOver = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    newRound()
                }
            }
        }
    }

    func nextLevel() {
        if level < 5 {
            level += 1
            score = 0
            hearts = 3
            newRound()
        } else {
            exitGame()
        }
    }

    func restartGame() {
        level = 1
        score = 0
        hearts = 3
        newRound()
    }
}
