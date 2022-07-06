//
//  SquareView.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/05.
//

import UIKit
import Combine

class SquareView: DrawingView {
    
    private let entity: SquareEntity

    init(entity: SquareEntity, userID: String) {
        self.entity = entity
        
        super.init(frame: entity.rect)
        
        self.selectable = userID == entity.owner
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContents() {
        super.configureContents()
        self.backgroundColor = selectable ? myRandomColor : otherOwnerColor
        self.entity.$rect
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rect in
                self?.frame = rect
                self?.setNeedsLayout()
            }
            .store(in: &disposeBag)
    }
    
    override func configureGestures() {
        super.configureGestures()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }
    
    @objc
    private func handlePan(_ sender: UIPanGestureRecognizer) {
        guard isSelected else { return }
        
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: self.superview)
            sender.setTranslation(.zero, in: self.superview)
            
            let prevRect = entity.rect
            let prevOrigin = prevRect.origin
            
            let newRect = CGRect(origin: CGPoint(x: prevOrigin.x + translation.x, y: prevOrigin.y + translation.y), size: prevRect.size)
            
            guard self.superview?.bounds.contains(newRect) ?? false else { return }
            
            entity.rect = newRect
        default:
            break
        }
    }
}

extension SquareView {
    var myRandomColor: UIColor {
        let colorCandidates: [UIColor] = [.systemCyan, .systemGray, .systemMint,
                                          .systemPink, .systemTeal, .systemBrown,
                                          .systemGreen, .systemIndigo, .systemOrange,
                                          .systemYellow, .systemPurple]
        return colorCandidates.randomElement() ?? .systemCyan
    }
    
    var otherOwnerColor: UIColor { return .systemBlue}
}
