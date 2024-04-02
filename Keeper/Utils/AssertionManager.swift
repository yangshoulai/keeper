//
//  AssertionManager.swift
//  Keeper2
//
//  Created by 杨寿来 on 2024/4/1.
//

import Foundation
import Cocoa
import IOKit.pwr_mgt

class AssertionManager {
    private(set) var assertionId : IOPMAssertionID = .zero
    
    private func isActive() -> Bool {
        return assertionId != IOPMAssertionID(0)
    }
    
    func create(timeout:CFTimeInterval, allowDisplaySleep: Bool) -> Bool{
        if !clear(){
            return false
        }
        let type = (allowDisplaySleep ? kIOPMAssertionTypeNoIdleSleep : kIOPMAssertionTypeNoDisplaySleep) as CFString
        let name = "Keeper" as CFString
        let timeoutAction = kIOPMAssertionTimeoutActionRelease as CFString
        let success = IOPMAssertionCreateWithDescription(
            type, name, nil, nil, nil, timeout, timeoutAction, &assertionId
        )
        return success == kIOReturnSuccess
    }
    
    
    func clear() -> Bool{
        if isActive(){
            let success =  IOPMAssertionRelease(assertionId)
            let r = success == kIOReturnSuccess
            if r {
                assertionId = .zero
            }
            return r
        }
        return true
    }
    
}
