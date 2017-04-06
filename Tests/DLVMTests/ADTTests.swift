//
//  ADTTests.swift
//  DLVM
//
//  Copyright 2016-2017 Richard Wei.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import struct DLVM.OrderedMapSet

class ADTTests: XCTestCase {

    func testOrderedMapSet() {
        /// Test CoW
        var set = OrderedMapSet<Int>()
        set.append(1)
        var setCopy = set
        setCopy.append(2)
        XCTAssertTrue(set.contains(1))
        XCTAssertFalse(set.contains(2))
        XCTAssertTrue(setCopy.contains(1))
        XCTAssertTrue(setCopy.contains(2))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
