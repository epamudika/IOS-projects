//
//  ColorMatchingGameApp.swift
//  ColorMatchingGame
//
//  Created by COBSCCOMP242P-051 on 2026-01-10.
//

import SwiftUI

@main
struct ColorMatchingGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct GameColor {
    let name: String
    let color: Color
}
import SwiftUI

struct ContentView: View {
    
    let colors: [GameColor] = [
        GameColor(name: "RED", color: .red),
        GameColor(name: "GREEN", color: .green),
        GameColor(name: "BLUE", color: .blue),
        GameColor(name: "YELLOW", color: .yellow)
    ]
    
    @State private var currentRound = 1
    @State private var score = 0
    @State private var targetColor: GameColor?
    @State private var gameOver = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Round \(currentRound)/3")
                .font(.headline)
            
            if let target = targetColor {
                Text("Match This Color:")
                Text(target.name)
                    .font(.largeTitle)
                    .bold()
            }
            
            HStack {
                ForEach(colors, id: \.name) { item in
                    Button(action: {
                        checkAnswer(selected: item)
                    }) {
                        Rectangle()
                            .fill(item.color)
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                    }
                }
            }
            
            Text("Score: \(score)")
                .font(.title2)
            
            if gameOver {
                Text("Game Over!")
                    .font(.largeTitle)
                    .bold()
                
                Button("Restart Game") {
                    resetGame()
                }
            }
        }
        .padding()
        .onAppear {
            startRound()
        }
    }
    
    // MARK: - Game Functions
    
    func startRound() {
        targetColor = colors.randomElement()
    }
    
    func checkAnswer(selected: GameColor) {
        if selected.name == targetColor?.name {
            score += 1
        }
        
        if currentRound < 3 {
            currentRound += 1
            startRound()
        } else {
            gameOver = true
        }
    }
    
    func resetGame() {
        currentRound = 1
        score = 0
        gameOver = false
        startRound()
    }
}
