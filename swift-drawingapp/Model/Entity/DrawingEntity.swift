//
//  DrawableEntity.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/04.
//

import Foundation
import CoreGraphics

protocol DrawingEntity {
    var id: String { get }
    var rect: CGRect { get set }
}
