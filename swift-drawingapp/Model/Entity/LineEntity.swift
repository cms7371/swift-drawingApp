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
    
    let linesRatioCoord: [[(x: Double, y: Double)]]
    
    init(id: String = UUID().uuidString, owner: String, rect: CGRect, lines: [[(x: Double, y: Double)]]) {
        self.id = id
        self.owner = owner
        self.rect = rect
        self.linesRatioCoord = lines
    }
    
    convenience init(cgLines: [[CGPoint]], owner: String) {
        // 이 책임을 LineEntity로 넘길 필요가 있을 것 같음
        let (minX, maxX) = cgLines.flatMap { $0 }
            .reduce((CGFloat.infinity, CGFloat(0))) { partialResult, point in
                let (currentMin, currentMax) = partialResult
                return (CGFloat.minimum(currentMin, point.x), CGFloat.maximum(currentMax, point.x))
            }
        let (minY, maxY) = cgLines.flatMap { $0 }
            .reduce((CGFloat.infinity, CGFloat(0))) { partialResult, point in
                let (currentMin, currentMax) = partialResult
                return (CGFloat.minimum(currentMin, point.y), CGFloat.maximum(currentMax, point.y))
            }
        
        let width = maxX - minX
        let height = maxY - minY
        
        let entityLines = cgLines.map { line in
            return line.map { point -> (Double, Double) in
                let relativeX = Double((point.x - minX) / width)
                let relativeY = Double((point.y - minY) / height)
                return (relativeX, relativeY)
            }
        }
        let entityRect = CGRect(x: minX, y: minY, width: width, height: height)
        
        self.init(owner: owner, rect: entityRect, lines: entityLines)
    }
}
