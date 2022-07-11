//
//  Canvas.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/11.
//

import Foundation
import CoreGraphics
import Combine

protocol DrawingUseCase {
    func addSquareEntity()
    func addLineEntity()
}

protocol DrawingPresenterPort: AnyObject {
    var bounds: CGRect { get }
    
    func addDrawingView(_ view: DrawingView)
}

class Canvas {
    let repository: EntityRepositoryPort
    unowned var presenter: DrawingPresenterPort
    
    let userID: String = "hayden"
    
    let selectedViewSubject = CurrentValueSubject<DrawingView?, Never>(nil)
    let prevSelectedViewSubject = CurrentValueSubject<DrawingView?, Never>(nil)
    var disposeBag = Set<AnyCancellable>()
    
    init(repository: EntityRepositoryPort, presenter: DrawingPresenterPort) {
        self.repository = repository
        self.presenter = presenter
        
        setUpSelectedViewSubject()
    }
    
    func setUpSelectedViewSubject() {
        
        selectedViewSubject.receive(on: DispatchQueue.main)
            .sink { [weak self] selectedView in
                let previousView = self?.prevSelectedViewSubject.value
                previousView?.deselect()
                self?.prevSelectedViewSubject.send(selectedView)
            }
            .store(in: &disposeBag)
    }

}

extension Canvas: DrawingUseCase {
    func addSquareEntity() {
        let entity = SquareEntity(ownerID: userID, in: presenter.bounds)
        let view = SquareView(entity: entity, userID: userID)
        view.setSelectedViewSubject(selectedViewSubject)
        
        presenter.addDrawingView(view)
    }
    
    func addLineEntity() {
        let view = LineView(userID: userID, frame: presenter.bounds)
        view.setSelectedViewSubject(selectedViewSubject)
        
        presenter.addDrawingView(view)
    }
}
