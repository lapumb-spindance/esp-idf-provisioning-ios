//
//  CustomEndpointResponse.swift
//  ESPProvision
//
//  Created by Blake Lapum on 7/21/20.
//  Copyright © 2020 Espressif. All rights reserved.
//

import Foundation

public class CustomEndpointResponse {
    public var respStr: String
    public var errCode: UInt32
    
    public init(respStr: String, errCode: UInt32) {
        self.respStr = respStr
        self.errCode = errCode
    }
    
    public func getRespStr() -> String {
        return respStr
    }
    
    public func getErrCode() -> UInt32 {
        return errCode
    }
}
