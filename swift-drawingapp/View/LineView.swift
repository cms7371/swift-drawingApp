//
//  LineView.swift
//  swift-drawingapp
//
//  Created by kakao on 2022/07/06.
//

import UIKit
import Combine

class LineView: UIView {
    
    @Published private var entity: LineEntity
    private let selectable: Bool
    @Published private var isSelected: Bool = false
    @Published private var isDrawing: Bool
    
    private var disposeBag = Set<AnyCancellable>()
    
    private weak var selectedViewSubject: CurrentValueSubject<UIView?, Never>?
    
    private var drawingLines = [[CGPoint]]()
    
    init(entity: LineEntity, userID: String, isDrawing: Bool = false) {
        self.entity = entity
        self.selectable = entity.owner == userID
        self.isDrawing = isDrawing
        
        super.init(frame: entity.rect)
        
        configureContents()
        configureGestures()
    }
    
    convenience init(userID: String, frame: CGRect) {
        let dummyEntity = LineEntity(id: UUID().uuidString, owner: userID, rect: frame, lines: [])
        
        self.init(entity: dummyEntity, userID: userID, isDrawing: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineCap(CGLineCap.round)
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(8.0)
        
        let lines: [[CGPoint]]
        
        if isDrawing{
            lines = drawingLines
        }
        else {
            let curRect = frame
            lines = entity.lines.map({ line in
                return line.map { relative in
                    let x = curRect.width * relative.x
                    let y = curRect.height * relative.y
                    return CGPoint(x: x, y: y)
                }
            })
        }
        lines.forEach { line in
            let _ = line.reduce(nil) { (prev: CGPoint?, current: CGPoint) -> CGPoint? in
                if let prev = prev {
                    context.beginPath()
                    context.move(to: prev)
                    context.addLine(to: current)
                    context.drawPath(using: .stroke)
                }
                return current
            }
        }
    }
    
    private func configureContents() {
        $isDrawing.receive(on: DispatchQueue.main)
            .sink { [weak self] isDrawing in
                self?.backgroundColor = isDrawing ? .lightGray : .clear
            }.store(in: &disposeBag)
        
        layer.borderWidth = 5
        $isSelected.receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
            }.store(in: &disposeBag)
        
        $entity
            .map { entity in
                return entity.$rect
            }.switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rect in
                self?.frame = rect
            }.store(in: &disposeBag)
        
    }
    
    private func configureGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }
    
    func setSelectedViewSubject(_ subject: CurrentValueSubject<UIView?, Never>) {
        self.selectedViewSubject = subject
    }
    
    @objc
    private func handleTap(_ sender: Any) {
        if isDrawing {
            finishDrawing()
        } else {
            if isSelected {
                selectedViewSubject?.send(nil)
            } else {
                selectedViewSubject?.send(self)
                isSelected = true
            }
        }
    }
    
    private func finishDrawing() {
        let (minX, maxX) = drawingLines.flatMap { $0 }
            .reduce((CGFloat.infinity, CGFloat(0))) { partialResult, point in
                let (currentMin, currentMax) = partialResult
                return (CGFloat.minimum(currentMin, point.x), CGFloat.maximum(currentMax, point.x))
            }
        let (minY, maxY) = drawingLines.flatMap { $0 }
            .reduce((CGFloat.infinity, CGFloat(0))) { partialResult, point in
                let (currentMin, currentMax) = partialResult
                return (CGFloat.minimum(currentMin, point.y), CGFloat.maximum(currentMax, point.y))
            }
        
        let width = maxX - minX
        let height = maxY - minY
        
        let entityLines = drawingLines.map { line in
            return line.map { point -> (Double, Double) in
                let relativeX = Double((point.x - minX) / width)
                let relativeY = Double((point.y - minY) / height)
                return (relativeX, relativeY)
            }
        }
        let entityRect = CGRect(x: minX, y: minY, width: width, height: height)
        
        let drawnEntity = LineEntity(id: UUID().uuidString, owner: entity.owner, rect: entityRect, lines: entityLines)
        self.entity = drawnEntity
        self.isDrawing = false
        setNeedsDisplay()
    }
    
    @objc
    private func handlePan(_ sender: UIPanGestureRecognizer) {
        if isDrawing {
            handleDrawingAction(sender)
        } else {
            handleViewPanning(sender)
        }
    }
    
    private func handleDrawingAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            drawingLines.append([sender.location(in: self)])
        case .changed:
            guard var line = drawingLines.popLast() else { return }
            line.append(sender.location(in: self))
            drawingLines.append(line)
            setNeedsDisplay()
        default:
            break
        }
    }
    
    private func handleViewPanning(_ sender: UIPanGestureRecognizer) {
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
}
