//
//  PushServiceAdapterTests.swift
//  
//
//  Created by Martin Dutra on 13/12/21.
//

import XCTest
@testable import Push

final class PushServiceAdapterTests: XCTestCase {

    private var apiService: APIServiceMock!
    private var service: PushServiceAdapter!

    override func setUp() {
        apiService = APIServiceMock()
        service = PushServiceAdapter(apiService: apiService)
    }

    func testUpdate() {
        service.update(nil, for: Identity(identifier: "")) { _ in }
        XCTAssertTrue(apiService.updated)
    }
}
