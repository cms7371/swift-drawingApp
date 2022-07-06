//
//  PenEntity.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/04.
//

import Foundation
import CoreGraphics

class LineEntity: DrawingEntity {
    let id: String
    let owner: String
    @Published var rect: CGRect
    
    let lines: [[(x: Double, y: Double)]]
    
    init(id: String = UUID().uuidString, owner: String, rect: CGRect, lines: [[(x: Double, y: Double)]]) {
        self.id = id
        self.owner = owner
        self.rect = rect
        self.lines = lines
    }
}
