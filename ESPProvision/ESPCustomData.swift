//
//  ESPCustomData.swift
//  ESPProvision
//
//  Created by Blake Lapum on 7/21/20.
//  Copyright © 2020 Espressif. All rights reserved.
//

import Foundation
import UIKit

public let ESP_CUSTOM_CONFIG_ENDPOINT: String = "custom-config"
public let ESP_CUSTOM_CONFIG_DEFAULT_ERR_CODE: UInt32 = 500
public let ESP_CUSTOM_CONFIG_SUCCESS: UInt32 = 0

class CustomData {
    private let session: ESPSession
    private let transportLayer: ESPCommunicable
    private let securityLayer: ESPCodeable

    /// Create CustomData object with a Session object
    /// Here the Provision class will require a session
    /// which has been successfully initialised by calling Session.initialize
    ///
    /// - Parameter session: Initialised session object
    init(session: ESPSession) {
        ESPLog.log("Initialising CustomData class.")
        self.session = session
        transportLayer = session.transportLayer
        securityLayer = session.securityLayer
    }

    /// Send custom configuration data to the customPath endpoint. The enpoint has three proto-buf parameters,
    /// key, str_info, and int_info
    ///
    /// - Parameters:
    ///   - key: Key value to which command should be hit on the ESP
    ///   - str_info: String info to be sent
    ///   - int_info: uint32 info to be sent
    func sendCustomData(key: UInt32,
                        str_info: String,
                        int_info: UInt32,
                        completionHandler: @escaping (CustomConfigResponse?, Error?) -> Swift.Void) {
        ESPLog.log("Sending custom data...")
        if session.isEstablished {
            do {
                let message = try createCustomRequest(key: key, str_info: str_info, int_info: int_info)
                if let message = message {
                    transportLayer.SendConfigData(path: ESP_CUSTOM_CONFIG_ENDPOINT, data: message) { response, error in
                        guard error == nil, response != nil else {
                            ESPLog.log("error sending custom config, error = \(error.debugDescription)")
                            completionHandler(self.createCustomResponse(), error)
                            return
                        }
                        let decodedResponse = self.processSendCustomDataResponse(response: response)
                        completionHandler(decodedResponse, nil)
                    }
                }
            } catch {
                ESPLog.log("failed sending custom data: error = \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    }

    /// Create a custom request that will be sent to a custom-endpoint.
    ///
    /// The custom endpoint will take three parameters:
    /// - Parameters
    ///     - key: specific key for which action you are executing at the endpoint
    ///     - str_info: some string info being sent
    ///     - int_info: some uint32 info being sent
    private func createCustomRequest(key: UInt32, str_info: String, int_info: UInt32) throws -> Data? {
        var configData = CustomConfigRequest()
        configData.configKey = key
        configData.strData = str_info
        configData.intData = int_info

        return try securityLayer.encrypt(data: configData.serializedData())
    }
    
    /// Helper to create a CustomConfigResponse, primarily used to build response if errors occur
    /// - Parameters
    ///    - status: status code, default invalidArgument
    ///    - respStr: response string, default ""
    ///    - errCode: error code, default ESP_CUSTOM_CONFIG_DEFAULT_ERR_CODE
    private func createCustomResponse(status: CustomConfigStatus = .invalidArgument, respStr: String = "", errCode: UInt32 = ESP_CUSTOM_CONFIG_DEFAULT_ERR_CODE) -> CustomConfigResponse {
        var resp = CustomConfigResponse()
        resp.status = status
        resp.respStr = respStr
        resp.errCode = errCode
        
        return resp
    }
    
    /// Process incoming response upon sending custom data.
    /// - Returns
    ///     - CustomConfigResponse
    private func processSendCustomDataResponse(response: Data?) -> CustomConfigResponse {
        ESPLog.log("process custom data response.")
        guard let response = response else {
            return createCustomResponse()
        }
        
        let decryptedResponse = securityLayer.decrypt(data: response)!
        do {
            let configResponse = try CustomConfigResponse(serializedData: decryptedResponse)
            return configResponse
        } catch {
            ESPLog.log(error.localizedDescription)
            return createCustomResponse(status: .internalError, respStr: "", errCode: ESP_CUSTOM_CONFIG_DEFAULT_ERR_CODE)
        }
    }
}
