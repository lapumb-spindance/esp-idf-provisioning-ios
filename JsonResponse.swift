//
//  JsonResponse.swift
//  ESPProvision
//
//  Created by Blake Lapum on 12/4/20.
//

import Foundation

public class JsonResponse {
    // A string in JSON format
    public var payload: String
    
    public init(payload: String) {
        self.payload = payload
    }
}
