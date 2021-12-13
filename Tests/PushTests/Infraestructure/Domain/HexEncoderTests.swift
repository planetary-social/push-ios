//
//  File.swift
//  
//
//  Created by Martin Dutra on 13/12/21.
//

import Foundation
@testable import Push
import XCTest

class HexEncoderTests: XCTest {

    var encoder: HexEncoder!

    override func setUp() {
        encoder = HexEncoder()
    }

    func testEncode() {
        let data = "test".data(using: .utf8)!
        XCTAssertEqual(encoder.encode(data: data), "74657374")
    }
}
