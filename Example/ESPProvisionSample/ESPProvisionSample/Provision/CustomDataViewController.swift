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
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var disconnectBtn: UIButton!
    
    var espDevice: ESPDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dismiss keyboard on outside tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBActions
    
    @IBAction func disconnectClicked(_ sender: Any) {
        disconnectAndPop()
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        
        // TODO: Send some JSON payload
        
//        Utility.showLoader(message: "Sending data..", view: self.view)
//        espDevice.sendJsonData(path: "", payload: "", completionHandler: { response in
//            Utility.hideLoader(view: self.view)
//            guard let resp = response else {
//                self.displayErrorAlert()
//                return
//            }
//
//            self.displayResult(response: resp)
//        })
    }
    
    // MARK: - Helpers
    private func disconnectAndPop() {
        espDevice.disconnect()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func displayErrorAlert() {
        let alert = UIAlertController(title: "Uh Oh..", message: "Something went wrong, response is nil", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            return
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func displayResult(response: JsonResponse) {
        let alert = UIAlertController(title: "received payload:", message: response.payload, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            return
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
