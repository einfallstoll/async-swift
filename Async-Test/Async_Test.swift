//
//  Async_Test.swift
//  Async-Test
//
//  Created by Fabio Poloni on 01.10.14.
//
//

import Cocoa
import XCTest

class Async_Test: XCTestCase {
    func testEach() {
        var expectation = self.expectationWithDescription("Async.each()")
        
        var items = ["Item 1", "Item 2"]
        var iteratorCount = 0
        var finishedCount = 0
        
        Async.each(items, iterator: { (item, asyncCallback) -> Void in
            
            XCTAssertEqual(item, items[iteratorCount], "Item does not match")
            XCTAssertLessThan(iteratorCount++, items.count, "Iterator was called too often")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                asyncCallback(error: nil)
            }
            
        }) { (error: String?) -> Void in
            
            XCTAssertLessThan(finishedCount++, 1, "Finished was called too often")
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testEachWithError() {
        var expectation = self.expectationWithDescription("Async.each() with error")
        
        var items = ["Item 1", "Item 2"]
        var expectedError = "This is an error"
        var iteratorCount = 0
        var finishedCount = 0
        
        Async.each(items , iterator: { (item, asyncCallback) -> Void in
            
            XCTAssertEqual(item, items[iteratorCount], "Item does not match")
            XCTAssertLessThan(iteratorCount++, items.count, "Iterator was called too often")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                asyncCallback(error: expectedError)
            }
            
        }) { (error: String?) -> Void in

            XCTAssertLessThan(finishedCount++, 1, "Finished was called too often")
            XCTAssertNotNil(error, "There was no error (and there should have been one)")
            XCTAssertEqual(error!, expectedError, "Error does not match")
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testEachSync() {
        var expectation = self.expectationWithDescription("Async.eachSync()")
        
        var items = ["Item 1", "Item 2"]
        var iteratorCount = 0
        var finishedCount = 0
        
        Async.eachSeries(items, iterator: { (item, asyncCallback) -> Void in
            
            XCTAssertEqual(item, items[iteratorCount], "Item does not match")
            XCTAssertLessThan(iteratorCount++, items.count, "Iterator was called too often")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                asyncCallback(error: nil)
            }
            
        }) { (error: String?) -> Void in
            
            XCTAssertLessThan(finishedCount++, 1, "Finished was called too often")
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testEachSyncWithError() {
        var expectation = self.expectationWithDescription("Async.eachSync() with error")
        
        var items = ["Item 1", "Item 2"]
        var expectedError = "This is an error"
        var iteratorCount = 0
        var finishedCount = 0
        
        Async.eachSeries(items, iterator: { (item, asyncCallback) -> Void in
            
            XCTAssertEqual(item, items[iteratorCount], "Item does not match")
            XCTAssertLessThan(iteratorCount++, items.count, "Iterator was called too often")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                asyncCallback(error: expectedError)
            }
            
            }) { (error: String?) -> Void in
                
                XCTAssertLessThan(finishedCount++, 1, "Finished was called too often")
                XCTAssertNotNil(error, "There was no error (and there should have been one)")
                XCTAssertEqual(error!, expectedError, "Error does not match")
                
                expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
