//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Abu Sayeed Roni on 2023-08-04.
//

import SwiftUI

enum Move {
    case rock, paper, scissors
    
    static func getString(for move: Move) -> String {
        switch move {
        case .rock:     return "Rock"
        case .paper:    return "Paper"
        case .scissors: return "Scissors"
        }
    }
    
    static func getRandomMove() -> Move {
        return [Move.rock, .paper, .scissors].randomElement()!
    }
}

enum MatchResult {
    case lose, win, tie
}

struct GameButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button { action() } label: {
            Image(imageName)
                .renderingMode(.original)
                .resizable(resizingMode: .stretch)
                .frame(maxWidth: 120, maxHeight: 120)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct ContentView: View {
    
    let maximumMoves = 10
    @State private var currentNumberOfMoves = 0
    
    @State private var currentMove = Move.getRandomMove()
    @State private var playerHasToWin = Bool.random() // Toggles between turns.
    @State private var playerScore = 0
    
    @State private var displayGameOverAlert: Bool = false
    let gameOverString = "Game Over"
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Score: \(playerScore)")
                .font(.title3)
            
            Spacer()
            
            VStack (spacing: 10) {
                Text("Play to \(playerHasToWin ? "Win": "Lose")")
                    .font(.title2)
                Text(Move.getString(for: currentMove))
                    .font(.largeTitle.weight(.heavy))
            }
            
            Spacer()

            HStack (spacing: 20) {
                GameButton(imageName: "rock") { buttonPressed(for: .rock)}
                GameButton(imageName: "paper") { buttonPressed(for: .paper)}
                GameButton(imageName: "scissors") { buttonPressed(for: .scissors)}
            }
            .padding()
            .alert(gameOverString, isPresented: $displayGameOverAlert) {
                Button ("Restart") { resetGame() }
            } message: {
                Text("Your final score: \(playerScore)")
            }
            
            
            Spacer()
        }
    }
    
    private func buttonPressed(for playerMove: Move) {
        
        // Check result.
        let matchResult = ContentView.userMatchResult(computerMove: currentMove, playerMove: playerMove, playerHasToWin: playerHasToWin)
        
        // Update score.
        if matchResult == .win {
            playerScore += 1
        } else if matchResult == .lose {
            playerScore -= 1
        }
        
        // Keep track of current number of moves.
        currentNumberOfMoves += 1
        
        // Handle when current number of moves hits the maximum number of moves.
        if currentNumberOfMoves == maximumMoves {
            displayGameOverAlert = true
        }
        
        // Prompt for the next move.
        nextMove()
    }
    
    private func nextMove() {
        currentMove = Move.getRandomMove()
        playerHasToWin.toggle()
    }
    
    private func resetGame() {
        currentNumberOfMoves = 0
        playerScore = 0
        nextMove()
    }
    
    private static func userMatchResultWhenUserHasToWin(computerMove: Move, playerMove: Move) -> MatchResult {
        if computerMove == .rock        && playerMove == .paper       { return .win}
        if computerMove == .rock        && playerMove == .scissors    { return .lose}
        
        if computerMove == .paper       && playerMove == .rock        { return .lose}
        if computerMove == .paper       && playerMove == .scissors    { return .win}
        
        if computerMove == .scissors    && playerMove == .rock        { return .win}
        if computerMove == .scissors    && playerMove == .paper       { return .lose}
        
        return .tie // Since, both of their moves are same at this point.
    }
    
    private static func userMatchResult(computerMove: Move, playerMove: Move, playerHasToWin: Bool) -> MatchResult {
        let matchResultWhenUserHasToWin = userMatchResultWhenUserHasToWin(computerMove: computerMove, playerMove: playerMove)
        
        if playerHasToWin {
            return matchResultWhenUserHasToWin
        }
        
        // User has to lose.
        if matchResultWhenUserHasToWin == .win { return .lose }
        if matchResultWhenUserHasToWin == .lose { return .win }
        return .tie // Since, a tie is always a tie.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
