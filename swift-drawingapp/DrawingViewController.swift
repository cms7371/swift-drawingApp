//
//  DrawingViewController.swift
//  swift-drawingapp
//
//  Created by JK on 2022/07/04.
//

import UIKit
import Combine

class DrawingViewController: UIViewController {
    var drawingUseCase: DrawingUseCase?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 의존성을 설정해주는 부분, 나중에 분리할 필요가 있을듯
        let repository = EntityRepository()
        drawingUseCase = Canvas(repository: repository, presenter: self)
    }
    
    @IBAction func touchUpAddSquare(_ sender: Any) {
        drawingUseCase?.addSquareEntity()
    }
    
    @IBAction func touchUpAddLine(_ sender: Any) {
        drawingUseCase?.addLineEntity()
    }
    
    @IBAction func touchUpSyncronization(_ sender: Any) {
    }
}

extension DrawingViewController: DrawingPresenterPort {
    var bounds: CGRect { return view.bounds }
    
    func addDrawingView(_ drawingView: DrawingView) {
        view.addSubview(drawingView)
    }
}
