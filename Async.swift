//
//  Async.swift
//  Async
//
//  Created by Fabio Poloni on 01.10.14.
//
//

import Foundation

struct Async {
    static func each<ArrayType, ErrorType>(arr: [ArrayType], iterator: @escaping (_ item: ArrayType, _ asyncCallback: (_ error: ErrorType?) -> Void) -> Void, finished: @escaping (_ error: ErrorType?) -> Void) {
        
        var isFinishedCalled = false
        let finishedOnce = { (error: ErrorType?) -> Void in
            if !isFinishedCalled {
                isFinishedCalled = true
                finished(error)
            }
        }
        
        DispatchQueue.global().async {
            var done = 0
            for item in arr {
                iterator(item) { (error) -> Void in
                    if error != nil {
                        finishedOnce(error)
                    } else {
                        done += 1
                        if (done >= arr.count) {
                            finishedOnce(nil)
                        }
                    }
                }
            }
        }
    }
    
    static func eachSeries<ArrayType, ErrorType>(arr: [ArrayType], iterator: @escaping (_ item: ArrayType, _ asyncCallback: (_ error: ErrorType?) -> Void) -> Void, finished: @escaping (_ error: ErrorType?) -> Void) {
        
        var arr = arr
        var isFinishedCalled = false
        let finishedOnce = { (error: ErrorType?) -> Void in
            if !isFinishedCalled {
                isFinishedCalled = true
                finished(error)
            }
        }
        
        var next: (() -> Void)?
        
        next = { () -> Void in
            if arr.count > 0 {
                let item = arr.remove(at: 0)
                iterator(item) { (error) -> Void in
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
        
        DispatchQueue.global().async {
            next!()
        }
    }
}
