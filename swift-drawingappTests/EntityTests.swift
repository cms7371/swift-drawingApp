//
//  swift_drawingappEntityTests.swift
//  swift-drawingappTests
//
//  Created by kakao on 2022/07/11.
//

import XCTest
@testable import swift_drawingapp

class EntityTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_SquareEntity_랜덤_생성() throws {
        let boundary = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        for _ in 0..<10 {
            let entity = SquareEntity(ownerID: "", in: boundary)
            XCTAssertTrue(boundary.contains(entity.rect))
        }
    }
    
    func test_LineEntity_CGPoint로_생성() throws {
        let drawnLine = [[CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 100), CGPoint(x: 100, y: 100), CGPoint(x: 100, y: 0)]]
        
        let entity = LineEntity(cgLines: drawnLine, owner: "")
        
        XCTAssertEqual(entity.rect, CGRect(x: 0, y: 0, width: 100, height: 100))
    }
}
