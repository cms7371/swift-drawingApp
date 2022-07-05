//
//  PenEntity.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/04.
//

import Foundation
import CoreGraphics

struct LineEntity: DrawingEntity {
    let id: String
    var rect: CGRect
    let points: [(y: Float, x: Float)]
}
