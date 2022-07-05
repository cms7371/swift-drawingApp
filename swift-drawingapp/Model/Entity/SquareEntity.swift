//
//  SquareEntity.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/04.
//

import Foundation
import UIKit
import Combine

class SquareEntity: DrawingEntity {
    let id: String
    let owner: String
    @Published var rect: CGRect
    
    init(id: String, owner: String, rect: CGRect) {
        self.id = id
        self.owner = owner
        self.rect = rect
    }
    
    convenience init(ownerID: String, in rect: CGRect) {
        let randomX = CGFloat.random(in: 0...(rect.width - 100))
        let randomY = CGFloat.random(in: 0...(rect.height - 100))
        let rect = CGRect(x: randomX, y: randomY, width: 100, height: 100)
        
        self.init(id: UUID().uuidString, owner: ownerID, rect: rect)
    }
}
