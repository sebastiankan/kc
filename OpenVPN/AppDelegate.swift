//
//  AppDelegate.swift
//  OpenVPN
//
//  Created by Roshit Omanakuttan on 05/06/18.
//  Copyright © 2018 Wow Labz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
     private let reachability = Reachability()!

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initApp()
        
        setupReachabilityChecker()
        
        return true
    }
    
    func initApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
    
    func setupReachabilityChecker() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            break
        case .cellular:
            break
        case .none:
            showConnectionError()
        }
    }
    
    private func showConnectionError() {
        
        let alert = UIAlertController(title: "ببووره‌! هه‌ڵه‌یه‌ك ڕوویدا",
                                      message: "تكایه‌ هێڵی ئینته‌رنێت كاراكه‌",
                                      preferredStyle: .alert)
        
        let checkAction = UIAlertAction(title: "دووبارە هەوڵبدەرەوە", style: .default) { _ in
            if self.reachability.connection != .none {
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.initApp()
            } else {
                self.showConnectionError()
            }
        }
        
        alert.addAction(checkAction)
        
        alert.preferredAction = checkAction
        
        guard let topViewController = UIApplication.topViewController() else { return }
        
        topViewController.present(alert, animated: true, completion: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        ViewController.manager?.connection.stopVPNTunnel()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        ViewController.manager?.connection.stopVPNTunnel()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        initApp()
    }
}

