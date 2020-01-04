//
//  GameWin.swift
//  TicTacToe
//
//  Created by Philip Smith on 12/20/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import SwiftUI

struct GameWin: View {
	var rows: Int = 3
	var cols: Int = 3
	var lineWidth: Int = 10
	@Binding var locations: [TileLocation]
	
    var body: some View {
		GeometryReader { geometry in
            Path { path in
				if let locationFirst = self.locations.first {
					path.move(to: self.findCenterTileFor(row: locationFirst.row, col: locationFirst.col, totalRows: self.rows, totalCols: self.cols, width: geometry.size.width, height: geometry.size.height))
				}
				
				if let locationLast = self.locations.last {
					path.addLine(to: self.findCenterTileFor(row: locationLast.row, col: locationLast.col, totalRows: self.rows, totalCols: self.cols, width: geometry.size.width, height: geometry.size.height))
				}
            }
			.stroke(Color("Strike"), style: StrokeStyle(lineWidth: CGFloat(self.lineWidth), lineCap: .round, lineJoin: .round))
		}
    }

	func findCenterTileFor(row: Int, col: Int, totalRows: Int, totalCols: Int, width: CGFloat, height: CGFloat) -> CGPoint {
		var point = CGPoint(x: 0, y: 0)
		
		// find x for point first
		let tileWidth = width / CGFloat(totalCols)
		point.x = width - (CGFloat(totalCols - col) * tileWidth) + (tileWidth / 2)
		
		// find y for point second
		let tileHeight = height / CGFloat(totalRows)
		point.y = height - (CGFloat(totalRows - row) * tileHeight) + (tileHeight / 2)
		
		return point
	}
}

struct GameWin_Previews: PreviewProvider {
	static let testLocation1 = [
		TileLocation(row: 1, col: 0),
		TileLocation(row: 1, col: 1),
		TileLocation(row: 1, col: 2),
	]
	
	static let testLocation2 = [
		TileLocation(row: 0, col: 1),
		TileLocation(row: 1, col: 1),
		TileLocation(row: 2, col: 1),
	]
	
	static let testLocation3 = [
		TileLocation(row: 2, col: 2),
		TileLocation(row: 1, col: 1),
		TileLocation(row: 0, col: 0),
	]
	
	static let locationBinding1 = Binding.constant(testLocation1)
	static let locationBinding2 = Binding.constant(testLocation2)
	static let locationBinding3 = Binding.constant(testLocation3)
	
    static var previews: some View {
		Group {
			GameWin(locations: locationBinding1).background(Color("Background"))
				.environment(\.colorScheme, .dark)
			GameWin(locations: locationBinding1).background(Color("Background"))
				.environment(\.colorScheme, .light)
			GameWin(locations: locationBinding2).background(Color("Background"))
				.environment(\.colorScheme, .dark)
			GameWin(locations: locationBinding2).background(Color("Background"))
				.environment(\.colorScheme, .light)
			GameWin(locations: locationBinding3).background(Color("Background"))
				.environment(\.colorScheme, .dark)
			GameWin(locations: locationBinding3).background(Color("Background"))
				.environment(\.colorScheme, .light)
		}
    }
}
