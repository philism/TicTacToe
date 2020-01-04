//
//  GameState.swift
//  TicTacToe
//
//  Created by Philip Smith on 12/15/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import SwiftUI
import Combine

enum GameModeType {
    case pvp 	// player vs player
    case pvc 	// player vs computer
    case pvl 	// player vs local player
	case pvrp 	// player vs remote player
	
	var description : String {
		switch self {
		
		case .pvp: return "Player vs. Player"
		case .pvc: return "Player vs. Computer"
		case .pvl: return "Player vs. Local Player"
		case .pvrp: return "Player vs. Remote Player"
	  }
	}
}

enum TileState {
    case empty
    case x
    case o
}

enum Player: CustomStringConvertible{
    case x
    case o
	
	var description : String {
		switch self {
		
		case .x: return "X"
		case .o: return "O"
	  }
	}
}

struct TileLocation: Hashable {
	var row: Int
	var col: Int
	
	var description : String {
		return "\(row),\(col)"
	}
	
	init(row: Int, col: Int) {
		self.row = row
		self.col = col
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(description.hashValue)
	}

    static func == (lhs: TileLocation, rhs: TileLocation) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
}

struct Tile {
	var player: Player?
	var winning: Bool = false
	
	var label: TileState
	var location: TileLocation
	
	init(label: TileState, location: TileLocation) {
		self.label = label
		self.location = location
	}
}

final class GameState: ObservableObject {
	@Published var gameStarted = false
	@Published var currentPlayer: Player = .x
	@Published var gameOver = false
	@Published var gameWinner : Player?
	@Published var gameWinLocations = [TileLocation]()
	@Published var gameModeType = GameModeType.pvp
	private var board = [[Tile]]()
	
	let rows : Int!
	let cols: Int!
	
	public convenience init() {
		self.init(rows: 3, cols: 3, mode: GameModeType.pvp)
	}
	
	public init(rows: Int, cols: Int, mode: GameModeType) {
		self.rows = rows
		self.cols = cols
		self.gameModeType = mode
		self.start()
	}
	
	func start() {
		currentPlayer = .x
		board = resetBoard()
		gameWinLocations = [TileLocation]()
		gameOver = false
		gameWinner = nil
	}

	func getTileFor(_ location: TileLocation) -> Tile {
		return board[location.row][location.col]
	}
	
	func setTileFor(tile: Tile, location: TileLocation) {
		board[location.row][location.col] = tile
	}
	
	func tappedTile(location: TileLocation){
		var tile = getTileFor(location)
		//print("tapped tile = \(tile)")
		if !gameOver && tile.label == TileState.empty {
			if currentPlayer == .x {
				tile.player = .x
				tile.label = .x
				self.setTileFor(tile: tile, location: location)
			} else {
				tile.player = .o
				tile.label = .o
				self.setTileFor(tile: tile, location: location)
			}
			if let winningTiles = self.winningTiles() {
				//print("winner found in tiles: \(winningTiles)")
				self.gameWinLocations = winningTiles.map({ return $0.location })
				setWinningTiles(locations: self.gameWinLocations)
				gameOver = true
				gameWinner = currentPlayer
			} else if noEmptySlotsLeft() {
				//print("game over")
				gameOver = true
			} else {
				//print("no winner, keep playing")
				self.nextPlayer()
			}
			
		} else {
			//print("tile isn't empty")
		}
		
	}
	
	func nextPlayer() {
		switch(self.currentPlayer) {
			case .x: self.currentPlayer = .o
			case .o: self.currentPlayer = .x
		}
	}
	
	private func noEmptySlotsLeft() -> Bool {
		// flatten 2d array and filter only empty tiles
		let emptyTiles = board.flatMap{ $0 }.filter( {$0.label == TileState.empty }).map({ return $0.location })
		//print("game over check \(emptyTiles)")
		return (emptyTiles.count == 0)
	}
	
	private func winningTiles() -> [Tile]? {
		
		// Check Diagonals First
		if let winTiles = equalButNotEmpty(forTiles: backSlashDiagonalValues() ) {
			return winTiles
		}
		
		if let winTiles = equalButNotEmpty(forTiles: fowardDiagonalValues() ) {
			return winTiles
		}
		
		// iterate rows third
		for r in 0..<rows {
			if let winTiles = equalButNotEmpty(forTiles: rowValues(r)) {
				return winTiles
			}
		}
		
		// iterate columns last
		for c in 0..<cols {
			if let winTiles = equalButNotEmpty(forTiles: colValues(c)) {
				return winTiles
			}
		}
		
		return nil
	}
	
	private func setWinningTiles(locations: [TileLocation] ) {
		for location in locations {
			var tile = self.board[location.row][location.col]
			tile.winning = true
			self.board[location.row][location.col] = tile
		}
	}
	
	private func resetBoard() -> [[Tile]] {
		var newBoard: [[Tile]] = Array(
					repeating:
						Array(
							repeating: Tile(label: .empty, location: TileLocation(row: 0, col: 0)),
							count: cols
						),
					count: rows
		)
		for r in 0..<rows {
			for c in 0..<cols {
				newBoard[r][c] = Tile(label: .empty, location: TileLocation(row: r, col: c))
			}
		}
		return newBoard
	}
	
	private func equalButNotEmpty(forTiles: [Tile]) -> [Tile]? {
		var allEqual: [Tile]?
		if let firstTile = forTiles.first {
			for tile in forTiles {
				switch (tile.label, firstTile.label) {
					case (.x, .x), (.o, .o):
						allEqual?.append(tile)
					default:
						return allEqual
				}
			}
			allEqual = forTiles
		}
		return allEqual
	}
	
	private func rowValues(_ row: Int) -> [Tile] {
		return board[row]
	}
	
	private func colValues(_ col: Int) -> [Tile] {
		return board.map{ $0[col]}
	}
	
	private func backSlashDiagonalValues() -> [Tile] {
		return board.enumerated().map { (index, element) in
			return element[index]
		}
	}
	
	private func fowardDiagonalValues() -> [Tile] {
		return board.enumerated().map { (index, element) in
			return element[board.count - 1 - index]
		}
	}
}

