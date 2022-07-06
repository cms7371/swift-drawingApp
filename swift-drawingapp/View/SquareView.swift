//
//  SquareView.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/05.
//

import UIKit
import Combine

class SquareView: UIView {
    
    private let entity: SquareEntity
    private let selectable: Bool
    @Published private var isSelected: Bool = false
    private var disposeBag: Set<AnyCancellable> = []
    
    private weak var selectedViewSubject: CurrentValueSubject<UIView?, Never>?

    init(entity: SquareEntity, userID: String) {
        self.entity = entity
        self.selectable = userID == entity.owner
        
        super.init(frame: entity.rect)
        
        configureContents()
        configureGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureContents() {
        self.backgroundColor = selectable ? myRandomColor : otherOwnerColor
        self.$isSelected.receive(on: DispatchQueue.main)
            .sink { [weak self] selected in
                self?.layer.borderWidth = selected ? 5 : 0
                self?.layer.borderColor = selected ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
            }
            .store(in: &disposeBag)
        self.entity.$rect
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rect in
                self?.frame = rect
                self?.setNeedsLayout()
            }
            .store(in: &disposeBag)
    }
    
    private func configureGestures() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }
    
    @objc
    private func handleTap(_ sender: Any) {
        if isSelected {
            selectedViewSubject?.send(nil)
        } else {
            isSelected = true
            selectedViewSubject?.send(self)
        }
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
    
    func deselect() {
        isSelected = false
    }
    
    func setSelectedViewSubject(_ subject: CurrentValueSubject<UIView?, Never>) {
        self.selectedViewSubject = subject
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
