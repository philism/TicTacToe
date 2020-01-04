//
//  GameStatus.swift
//  TicTacToe
//
//  Created by Philip Smith on 12/22/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import SwiftUI

struct GameStatus: View {
	@EnvironmentObject var gameState: GameState
	
	//var flipped : Bool = false
	
    var body: some View {
        gameStatusView()
    }
	
	func gameStatusView() -> AnyView {
		var statusString = "n/a"
		
		if gameState.gameOver {
			statusString = "Game Over"
			if let player = gameState.gameWinner {
				statusString += ", " + player.description + " wins!"
			} else {
				statusString += ", draw."
			}
		} else {
			// game is not over, show current player
			statusString = "Current player: " + gameState.currentPlayer.description
		}
		return AnyView(
			Text(statusString)
				.foregroundColor(Color("Text"))
		)
	}
}

struct GameStatus_Previews: PreviewProvider {
	static var gameState = GameState()
	
    static var previews: some View {
		Group {
			GameStatus()
				.environmentObject(gameState)
				.background(Color("Background"))
				.environment(\.colorScheme, .light)
			GameStatus()
				.environmentObject(gameState)
				.background(Color("Background"))
				.environment(\.colorScheme, .dark)
		}
    }
}
