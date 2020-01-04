//
//  GameGrid.swift
//  TicTacToe
//
//  Created by Philip Smith on 12/19/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//

import SwiftUI

struct GameGrid: View {
	var rows: Int = 3
	var cols: Int = 3
	var lineWidth: Int = 5
	
    var body: some View {
		GeometryReader { geometry in
            Path { path in
				let numberOfHorizontalGridLines = self.rows - 1
				let numberOfVerticalGridLines = self.cols - 1
				let horizontalSpacing = geometry.size.width / CGFloat(self.cols)
				let verticalSpacing = geometry.size.height / CGFloat(self.rows)
                for index in 1...numberOfVerticalGridLines {
                    let vOffset: CGFloat = CGFloat(index) * horizontalSpacing
                    path.move(to: CGPoint(x: vOffset, y: CGFloat(self.lineWidth)))
                    path.addLine(to: CGPoint(x: vOffset, y: geometry.size.height - CGFloat(self.lineWidth)))
                }
                for index in 1...numberOfHorizontalGridLines {
                    let hOffset: CGFloat = CGFloat(index) * verticalSpacing
                    path.move(to: CGPoint(x: CGFloat(self.lineWidth), y: hOffset))
                    path.addLine(to: CGPoint(x: geometry.size.width - CGFloat(self.lineWidth), y: hOffset))
                }
            }
			.stroke(Color("Grid"), style: StrokeStyle(lineWidth: CGFloat(self.lineWidth), lineCap: .round, lineJoin: .round))
		}
    }
}

struct GameGrid_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			GameGrid()
				.background(Color("Background"))
				.environment(\.colorScheme, .dark)
			GameGrid()
				.background(Color("Background"))
				.environment(\.colorScheme, .light)
		}
    }
}
