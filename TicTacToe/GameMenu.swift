//
//  GameMenu.swift
//  TicTacToe
//
//  Created by Philip Smith on 12/15/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import SwiftUI

struct GridType: Identifiable, Hashable {
	let id = UUID()
	let name: String
	let rows: Int
	let cols: Int
}

var gridTypes = [
	GridType(name: "3x3", rows: 3, cols: 3),
	GridType(name: "5x5", rows: 5, cols: 5),
	GridType(name: "7x7", rows: 7, cols: 7),
]

struct GameMode: Identifiable, Hashable {
	let id = UUID()
	var name: String
	var type: GameModeType
	
	init(type: GameModeType) {
		self.type = type
		self.name = type.description
	}
	
	init(name: String, type: GameModeType) {
		self.name = name
		self.type = type
	}
}

var gameModes = [
	GameMode(type: GameModeType.pvp),
	GameMode(type: GameModeType.pvc),
	GameMode(type: GameModeType.pvl),
	GameMode(type: GameModeType.pvrp)
]

struct GameMenu: View {
	@State var gridTypeSelected: GridType?
	@State var gameModeSelected: GameMode?
	@State var gameState: GameState = GameState()
	
    var body: some View {
		NavigationView {
			VStack(alignment: .leading, spacing: 5) {
				Text("Grid Type:")
					.font(.headline)
					.fontWeight(.bold)
				HStack(alignment: .top, spacing: 0) {
					ForEach(gridTypes, id:\.self ) { gridType in
						GridSelectableRow(gridType: gridType, selected: self.$gridTypeSelected)
					}
				}
				Divider()
				Text("Game Mode:")
					.font(.headline)
					.fontWeight(.bold)
				List(gameModes) { gameMode in
					GameSelectableRow(gameMode: gameMode, selected: self.$gameModeSelected)
				}
				Divider()
				NavigationLink(destination: GameBoard().environmentObject(gameState)){
					Text("StartGame")
				}
			}
			.navigationBarTitle(Text("Game Menu"))
		}
	}
}

struct GridSelectableRow: View {
    let gridType: GridType
    @Binding var selected: GridType?

    var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading, spacing: 4) {
				GameGrid(rows: self.gridType.rows, cols: self.gridType.cols, lineWidth: 1)
					.frame(width: (geometry.size.width / CGFloat(2)), height: (geometry.size.height / CGFloat(5)), alignment: .center)
					.foregroundColor(Color("Grid"))
					.background(Color.gray)
				HStack(alignment: .center, spacing: 5) {
					Image(systemName: self.selected != nil ? "checkmark.square" : "square")
					Text(self.gridType.name)
						.foregroundColor(Color("Text"))
				}
			}
			.padding(4)
			.onTapGesture {
				self.selected = self.gridType
			}
			
		}
	}
}

struct GameSelectableRow: View {
    let gameMode: GameMode
    @Binding var selected: GameMode?

    var body: some View {
        GeometryReader { geo in
            HStack {
				Image(systemName: self.selected != nil ? "checkmark.square" : "square")
                Text(self.gameMode.name).frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
            }
			.background(self.selected != nil ? Color.gray : Color.clear)
			.onTapGesture {
				self.selected = self.gameMode
			}
        }
    }
}

struct GameMenu_Previews: PreviewProvider {
    static var previews: some View {
        GameMenu()
    }
}
