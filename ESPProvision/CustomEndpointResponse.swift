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
    public var errCode: Int32
    
    public init(respStr: String, errCode: Int32) {
        self.respStr = respStr
        self.errCode = errCode
    }
    
    public func isSuccess() -> Bool {
        return self.errCode == ESP_CUSTOM_CONFIG_SUCCESS
    }
}
