//
//  PushTests.swift
//
//
//  Created by Martin Dutra on 30/11/21.
//

import XCTest
@testable import Push

final class PushTests: XCTestCase {

    private var service: PushServiceMock!
    private var push: Push!

    override func setUp() {
        service = PushServiceMock()
        push = Push(service: service)
    }

    func testUpdate() {
        push.update(nil, for: "") { _ in }
        XCTAssertTrue(service.updated)
    }
}
