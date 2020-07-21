//
//  CustomDataViewController.swift
//  ESPProvisionSample
//
//  Created by Blake Lapum on 7/21/20.
//  Copyright © 2020 Espressif. All rights reserved.
//

import Foundation
import UIKit
import ESPProvision

class CustomDataViewController: UIViewController {
    
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var stringDataTextField: UITextField!
    @IBOutlet weak var intDataTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var disconnectBtn: UIButton!
    
    var espDevice: ESPDevice!
    var key: UInt32!
    var strData: String!
    var intData: UInt32!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dismiss keyboard on outside tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBActions
    
    @IBAction func keyChange(_ sender: Any) {
        // if there is no value, set to an invalid val
        key = UInt32(keyTextField.text ?? "1000")
    }
    
    @IBAction func stringDataChange(_ sender: Any) {
        strData = stringDataTextField.text ?? ""
    }

    @IBAction func intDataChange(_ sender: Any) {
        intData = UInt32(intDataTextField.text ?? "0")
    }

    @IBAction func cancelClicked(_ sender: Any) {
        disconnectAndPop()
    }
    
    @IBAction func disconnectClicked(_ sender: Any) {
        disconnectAndPop()
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        if !inputIsValid() {
            print("input invalid, cannot send data.")
            return
        }
        
        print("Sending data: key: \(key ?? 1000), string data: \(strData ?? ""), int data: \(intData ?? 1000)")
        Utility.showLoader(message: "Sending data..", view: self.view)
        espDevice.sendCustomData(key: key, str_info: strData, int_info: intData, completionHandler: { response in
            Utility.hideLoader(view: self.view)
            self.displayResult(response: response ?? CustomEndpointResponse(respStr: "Failed to parse response", errCode: ESP_CUSTOM_CONFIG_DEFAULT_ERR_CODE))
        })
    }
    
    // MARK: - Helpers
    private func inputIsValid() -> Bool {
        // TODO: clean up; need more explicit validation
        let tempKey = key ?? 1000
        let tempStr = strData ?? nil
        let tempInt = intData ?? 1000
        
        return tempKey < 1000 && tempStr != nil && tempInt < 1000
    }
    
    private func disconnectAndPop() {
        espDevice.disconnect()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func displayResult(response: CustomEndpointResponse) {
        let title: String = response.errCode == ESP_CUSTOM_CONFIG_SUCCESS ? "Success" : "Failure"
        let message: String = response.getRespStr() == "" ? "Failed to parse response" : response.getRespStr()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            return
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
