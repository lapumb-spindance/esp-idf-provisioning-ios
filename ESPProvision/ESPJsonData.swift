//
//  ESPJsonData.swift
//  ESPProvision
//
//  Created by Blake Lapum on 12/4/20.
//

import Foundation
import UIKit

class JsonData {
    private let session: ESPSession
    private let transportLayer: ESPCommunicable
    private let securityLayer: ESPCodeable

    /// Create CustomData object with a Session object
    /// Here the Provision class will require a session
    /// which has been successfully initialised by calling Session.initialize
    ///
    /// - Parameter session: Initialised session object
    init(session: ESPSession) {
        ESPLog.log("Initialising JsonData class.")
        self.session = session
        transportLayer = session.transportLayer
        securityLayer = session.securityLayer
    }

    /// Send custom configuration data to the customPath endpoint. The enpoint has three proto-buf parameters,
    /// key, str_info, and int_info
    ///
    /// - Parameters:
    ///   - path: The path to send the JSON message to
    ///   - str_info: Strig-afied JSON payload
    func sendJsonData(path: String,
                        json_string: String,
                        completionHandler: @escaping (JsonPayload?, Error?) -> Swift.Void) {
        ESPLog.log("Sending json payload..")
        if session.isEstablished {
            do {
                let message = try createJsonPayloadRequest(payload: json_string)
                if let message = message {
                    transportLayer.SendConfigData(path: path, data: message) { response, error in
                        guard error == nil, response != nil else {
                            ESPLog.log("error sending json payload, error = \(error.debugDescription)")
                            completionHandler(self.createJsonPayloadResponse(), error)
                            return
                        }
                        let decodedResponse = self.processSendJsonPayloadResponse(response: response)
                        completionHandler(decodedResponse, nil)
                    }
                }
            } catch {
                ESPLog.log("failed sending json payload: error = \(error.localizedDescription)")
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
    private func createJsonPayloadRequest(payload: String) throws -> Data? {
        var data = JsonPayload()
        data.jsonPayload = payload

        return try securityLayer.encrypt(data: data.serializedData())
    }
    
    /// Helper to create a CustomConfigResponse, primarily used to build response if errors occur
    /// - Parameters
    ///    - status: status code, default invalidArgument
    ///    - respStr: response string, default ""
    ///    - errCode: error code, default ESP_CUSTOM_CONFIG_DEFAULT_ERR_CODE
    private func createJsonPayloadResponse(payload: String = "{\"status\":\"failure\"}") -> JsonPayload {
        var resp = JsonPayload()
        resp.jsonPayload = payload
        
        return resp
    }
    
    /// Process incoming response upon sending custom data.
    /// - Returns
    ///     - CustomConfigResponse
    private func processSendJsonPayloadResponse(response: Data?) -> JsonPayload {
        ESPLog.log("process custom data response")
        guard let resp = response else {
            ESPLog.log("response is nil")
            return createJsonPayloadResponse(payload: "{\"status\":\"failure.. response is nil\"}")
        }
        
        ESPLog.log("------------------ Response byte count: \(resp.bytes.count) ------------------")
        
        let decryptedResponse = securityLayer.decrypt(data: resp)!
        do {
            let response = try JsonPayload(serializedData: decryptedResponse)
            ESPLog.log("response received: \(response.jsonPayload)")
            return response
        } catch {
            ESPLog.log("error decrypting data, error = \(error.localizedDescription)")
            
            if let decodingError = error as? DecodingError {
                print("Decrypt error: \(decodingError.errorDescription ?? "ahhhhh oh no")")
            }
            
            return createJsonPayloadResponse(payload: "{\"status\":\"Error decrypting data - \(error.localizedDescription)")
        }
    }

}
