//
//  Async.swift
//  Async
//
//  Created by Fabio Poloni on 01.10.14.
//
//

import Foundation

struct Async {
    static func each<ArrayType, ErrorType>(arr: [ArrayType], iterator: (item: ArrayType, asyncCallback: (error: ErrorType?) -> Void) -> Void, finished: (error: ErrorType?) -> Void) {
        
        var isFinishedCalled = false
        var finishedOnce = { (error: ErrorType?) -> Void in
            if !isFinishedCalled {
                isFinishedCalled = true
                finished(error: error)
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            var done = 0
            for item in arr {
                iterator(item: item) { (error) -> Void in
                    if error != nil {
                        finishedOnce(error)
                    } else if (++done >= arr.count) {
                        finishedOnce(nil)
                    }
                }
            }
        }
    }
    
    static func eachSeries<ArrayType, ErrorType>(var arr: [ArrayType], iterator: (item: ArrayType, asyncCallback: (error: ErrorType?) -> Void) -> Void, finished: (error: ErrorType?) -> Void) {
        
        var isFinishedCalled = false
        var finishedOnce = { (error: ErrorType?) -> Void in
            if !isFinishedCalled {
                isFinishedCalled = true
                finished(error: error)
            }
        }
        
        var next: (() -> Void)?
        
        next = { () -> Void in
            if arr.count > 0 {
                let item = arr.removeAtIndex(0)
                iterator(item: item) { (error) -> Void in
                    if error != nil {
                        finishedOnce(error)
                    } else {
                        next!()
                    }
                }
            } else {
                finishedOnce(nil)
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            next!()
        }
    }
}
