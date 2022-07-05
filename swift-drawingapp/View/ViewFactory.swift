//
//  ViewFactory.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/05.
//

import Foundation
import UIKit

class ViewFactory {
    func getNewSquareView(with userID: String, in bound: CGRect) -> SquareView {
        let entity = SquareEntity(ownerID: userID, in: bound)
        
        return SquareView(entity: entity, userID: userID)
    }
}
