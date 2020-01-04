//
//  GameTile.swift
//  TicTacToe
//
//  Created by Philip Smith on 12/19/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import SwiftUI

struct GameTile: View {
	@Binding var tile : Tile
	
    var body: some View {
		/*tileStateView()*/
		ZStack {
			Rectangle()
				.fill( Color("Empty") )
				.cornerRadius(CGFloat(10))
				.padding(5)
			tileStateView()
		}
	}
	
	func tileStateView() -> AnyView {
		var systemImage: String
		var stateColor: Color
		switch tile.label {
			case .empty:
				systemImage = "square.fill"
				stateColor = Color("Empty")
			case .x:
				systemImage = "xmark"
				stateColor = Color("xmark")
			case .o:
				systemImage = "circle"
				stateColor = Color("circle")
		}
		/*if tile.winning {
			stateColor = Color("Strike")
		}*/
		return AnyView(
			Image(systemName: systemImage)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.foregroundColor(stateColor)
				.padding(5)
		)
	}
}

struct GameTile_Previews: PreviewProvider {
	static let tileX = Tile(label: TileState.x, location: TileLocation(row: 0, col: 0))
	static let tileO = Tile(label: TileState.o, location: TileLocation(row: 0, col: 0))
	
	static let tileXBinding = Binding.constant(tileX)
	static let tileOBinding = Binding.constant(tileO)
	
    static var previews: some View {
		Group {
			GameTile(tile: tileXBinding)
				.background(Color("Background"))
				.environment(\.colorScheme, .light)
			GameTile(tile: tileXBinding)
				.background(Color("Background"))
				.environment(\.colorScheme, .dark)
			GameTile(tile: tileOBinding)
				.background(Color("Background"))
				.environment(\.colorScheme, .light)
			GameTile(tile: tileOBinding)
				.background(Color("Background"))
				.environment(\.colorScheme, .dark)
		}
    }
}
