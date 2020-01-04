//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Philip Smith on 12/15/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import SwiftUI

struct GameBoard: View {
	@EnvironmentObject var gameState: GameState
    var body: some View {
        VStack {
			GameStatus()
			ZStack {

				GameGrid(rows: self.gameState.rows, cols: self.gameState.cols, lineWidth: 5)
				VStack{
					ForEach(0..<self.gameState.rows, id:\.self) { row in
						HStack {
							ForEach(0..<self.gameState.cols, id:\.self) { col in
								Button(action: {
									self.gameState.tappedTile(location: TileLocation(row: row, col: col))
								} ) {
									GameTile(tile:
										Binding(
											get: {
												return self.gameState.getTileFor( TileLocation(row: row, col: col) )
											},
											set: { (newValue) in
												return self.gameState.setTileFor(tile: newValue, location: TileLocation(row: row, col: col) )
											}
										)
									)
								}.accessibility(label: Text("Game tile for row \(row) and column \(col)."))
							}
						}
					}
				}
				GameWin(locations:
					Binding(
						get: {
							return self.gameState.gameWinLocations
						},
						set: { (newValue) in
							return self.gameState.gameWinLocations = newValue
						}
					)
				)
			}
			
		}
    }

}

struct GameBoard_Previews: PreviewProvider {
	
    static var previews: some View {
		Group {
			GameBoard()
				.environmentObject(GameState())
				.background(Color("Background"))
				.environment(\.colorScheme, .light)
			GameBoard()
				.environmentObject(GameState())
				.background(Color("Background"))
				.environment(\.colorScheme, .dark)
		}
    }
}
