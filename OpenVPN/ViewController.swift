//
//  ViewController.swift
//  OpenVPN
//
//  Created by Roshit Omanakuttan on 05/06/18.
//  Copyright © 2018 Wow Labz. All rights reserved.
//


import UIKit
import OpenVPNAdapter
import NetworkExtension
import WebKit

class ViewController: ViewControllerInterface {
    
    // MARK: - Properties
    
    static var manager: NETunnelProviderManager?
    
    var webVC: WebViewController!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VPNStatusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            if let vpn = managers?.filter({ $0.localizedDescription == "Kubak Credit iOS Client" }).first {
                if vpn.connection.status == .connected {
                    self.openWebView()
                } else {
                    self.establishVPNConnection()
                }
            }
        }
        allowButton.addTarget(self, action: #selector(establishVPNConnection), for: .touchUpInside)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func connectVpn(_ options: [String : NSObject]) {
        do {
            try ViewController.manager?.connection.startVPNTunnel(options: options)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    @objc private func establishVPNConnection() {
        let callback = { (error: Error?) -> Void in
            ViewController.manager?.loadFromPreferences(completionHandler: { (error) in
                guard error == nil else {
                    print("\(error!.localizedDescription)")
                    return
                }
                
                let options = self.generateUserPass()
                
                self.connectVpn(options)
            })
        }
        
        configureVPN(callback: callback)
    }
    
    private func generateUserPass()-> [String:NSObject] {
        return [
            "username": "" as NSString,
            "password": "" as NSString
        ]
    }
    
    @objc func willResignActive(_ notification: Notification) {
        // code to execute
        connectVpn(generateUserPass())

    }
    
    
    @objc private func disconnectVPN() {
    }
    
    
    private func presentLoading() {
        if let vc = webVC {
            vc.presentLoading()
        }
    }
    
    private func dismissLoading() {
        if let vc = webVC {
            vc.dismissLoading()
        }
    }
    
    @objc private func VPNStatusDidChange(_ notification: Notification?) {
        if ViewController.manager != nil {
            let status = (ViewController.manager?.connection.status)!
            switch status {
            case .connecting:
                print("connecting")
                presentLoading()
                self.loading(true)
                break
            case .connected:
                print("connected")
                dismissLoading()
                self.openWebView()
                break
            case .disconnecting:
                print("disconnecting")
//                showConnectionError(with: "در فرایند برقراری ارتباط با سرور خطایی پیش آمده")
                break
            case .disconnected:
                print("disconnected")
//                showConnectionError(with: "در فرایند برقراری ارتباط با سرور خطایی پیش آمده")
                break
            case .invalid:
                print("invalid")
                showConnectionError(with: "Invalid VPN")
                break
            case .reasserting:
                print("Reasserting...")
                break
            }
        }
    }
    
    private func showConnectionError(with message: String) {
        
        let alert = UIAlertController(title: "ببووره‌! هه‌ڵه‌یه‌ك ڕوویدا",
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "باشه‌، به‌رده‌وامبه‌", style: .cancel) { _ in
            
        }
        
        alert.addAction(okAction)
        
        alert.preferredAction = okAction
        
        guard let topViewController = UIApplication.topViewController() else { return }
        
        topViewController.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func presentWebViewController() {
        webVC = WebViewController()
        webVC.modalPresentationStyle = .fullScreen
        present(self.webVC, animated: true)
    }
    
    func openWebView() {
        if let _ = webVC { return }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.presentWebViewController()
        }
    }
    
}


extension ViewController {
    
    // MARK: -
    
    func configureVPN(callback: @escaping (Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                callback(error)
                return
            }
            
            ViewController.manager = managers?.first ?? NETunnelProviderManager()
            ViewController.manager?.loadFromPreferences(completionHandler: { (error) in
                guard error == nil else {
                    print("\(error!.localizedDescription)")
                    callback(error)
                    return
                }
                
                let configurationFile = Bundle.main.url(forResource: "client", withExtension: "ovpn")
                let configurationContent = try! Data(contentsOf: configurationFile!)
                
//                if let storedContent = UserDefaults.standard.data(forKey: "kbkc_ovpn") {
//                    configurationContent = storedContent
//                }
                
                let tunnelProtocol = NETunnelProviderProtocol()
                tunnelProtocol.serverAddress = ""
                tunnelProtocol.providerBundleIdentifier = "co.kubak.credit.OpenVPNTunnelProvider"
                tunnelProtocol.providerConfiguration = ["configuration": configurationContent]
                
                tunnelProtocol.disconnectOnSleep = false
                
                ViewController.manager?.protocolConfiguration = tunnelProtocol
                ViewController.manager?.localizedDescription = "Kubak Credit iOS Client"
                
                ViewController.manager?.isEnabled = true
                
                ViewController.manager?.saveToPreferences(completionHandler: { (error) in
                    guard error == nil else {
                        print("\(error!.localizedDescription)")
                        callback(error)
                        return
                    }
                    
                    callback(nil)
                })
            })
        }
    }
    
}

