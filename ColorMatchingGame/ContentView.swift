
//
//  ContentView.swift
//  ColorMtchingGame2
//
//  Created by COBSCCOMP242P-051 on 2026-01-17.
//

import SwiftUI

let gameColors: [Color] = [
    .brown, .blue, .green,
    .yellow, .orange, .purple,
    .pink, .cyan, .mint
]

struct ContentView: View {

    
    @State private var targetColor: Color = .red
    @State private var score: Int = 0
    @State private var message: String = "Match the color!"

    // Grid layout: 3 columns
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)

    var body: some View {
        VStack(spacing: 20) {

            // Title
            Text("Color Matching Game")
                .font(.largeTitle)
                .bold()

            // Message
            Text(message)
                .font(.headline)

            // Score
            Text("Score: \(score)")
                .font(.title2)

            // Target Color Display
            Rectangle()
                .fill(targetColor)
                .frame(width: 140, height: 140)
                .cornerRadius(12)

            // 3x3 Color Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(gameColors.indices, id: \.self) { index in
                    let color = gameColors[index]

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
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            newRound()
        }
    }

    

    func newRound() {
        if let randomColor = gameColors.randomElement() {
            targetColor = randomColor
            message = "Match the color!"
        }
    }

    func checkAnswer(_ color: Color) {
        if color == targetColor {
            score += 1
            message = "Correct!"
        } else {
            message = "Try Again!"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            newRound()
        }
    }
}

#Preview {
    ContentView()
}


