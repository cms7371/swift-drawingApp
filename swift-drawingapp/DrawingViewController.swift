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
    
    let selctedViewSubject = CurrentValueSubject<DrawingView?, Never>(nil)
    var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelectedViewSubject()
    }
    
    @IBAction func touchUpAddSquare(_ sender: Any) {
        let squareView = viewFactory.getNewSquareView(with: userID, in: view.bounds)
        squareView.setSelectedViewSubject(selctedViewSubject)
        view.addSubview(squareView)
    }
    
    @IBAction func touchUpAddLine(_ sender: Any) {
        let lineView = viewFactory.getNewLineView(with: userID, in: view.bounds)
        lineView.setSelectedViewSubject(selctedViewSubject)
        view.addSubview(lineView)
    }
    
    @IBAction func touchUpSyncronization(_ sender: Any) {
    }
    
    func setUpSelectedViewSubject() {
        let previousBuffer = CurrentValueSubject<DrawingView?, Never>(nil)
        
        selctedViewSubject.receive(on: DispatchQueue.main)
            .sink { selectedView in
                let previousView = previousBuffer.value
                previousView?.deselect()
                previousBuffer.send(selectedView)
            }
            .store(in: &disposeBag)
    }

}

