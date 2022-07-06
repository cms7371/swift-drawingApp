//
//  DrawingView.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/06.
//

import UIKit
import Combine

class DrawingView: UIView {

    var selectable: Bool = true
    @Published var isSelected: Bool = false
    
    var disposeBag: Set<AnyCancellable> = []
    weak var selectedViewSubject: CurrentValueSubject<DrawingView?, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        configureContents()
        configureGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        self.$isSelected.receive(on: DispatchQueue.main)
            .sink { [weak self] selected in
                self?.layer.borderWidth = selected ? 5 : 0
                self?.layer.borderColor = selected ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
            }
            .store(in: &disposeBag)
    }
    
    func configureGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    @objc
    func handleTap(_ sender: Any) {
        if isSelected {
            selectedViewSubject?.send(nil)
        } else {
            isSelected = true
            selectedViewSubject?.send(self)
        }
    }
    
    func deselect() {
        isSelected = false
    }
    
    func setSelectedViewSubject(_ subject: CurrentValueSubject<DrawingView?, Never>) {
        self.selectedViewSubject = subject
    }
}
