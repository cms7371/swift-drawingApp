//
//  DrawingViewController.swift
//  swift-drawingapp
//
//  Created by JK on 2022/07/04.
//

import UIKit
import Combine

class DrawingViewController: UIViewController {
    
    let viewFactory = ViewFactory()
    // 임시
    let userID: String = "hayden"
    
    let selctedViewSubject = CurrentValueSubject<UIView?, Never>(nil)
    var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelectedViewSubject()
    }
    
    @IBAction func touchUpAddSquare(_ sender: Any) {
        let squareView = viewFactory.getNewSquareView(with: userID, in: view.bounds)
        // 이 부분도 프로토콜을 빼서 추상화 해야함
        squareView.setSelectedViewSubject(selctedViewSubject)
        view.addSubview(squareView)
    }
    
    @IBAction func touchUpAddLine(_ sender: Any) {
    }
    
    @IBAction func touchUpSyncronization(_ sender: Any) {
    }
    
    func setUpSelectedViewSubject() {
        let previousBuffer = CurrentValueSubject<UIView?, Never>(nil)
        
        selctedViewSubject.receive(on: DispatchQueue.main)
            .sink { selectedView in
                let previousView = previousBuffer.value
                // 임시(SquareView의 상위 뷰로 바꿔줘야함)
                (previousView as? SquareView)?.deselect()
                previousBuffer.send(selectedView)
            }
            .store(in: &disposeBag)
    }

}

