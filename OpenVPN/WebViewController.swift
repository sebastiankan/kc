//
//  WebViewController.swift
//  Kubak Credit
//
//  Created by Farid on 9/7/19.
//  Copyright © 2019 Kubak. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: LoadingViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    let progressBar = LinearProgressBar()
    var loadingVC: LoadingViewController!
    
    func presentLoading() {
        if let _ = loadingVC { return }
        loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: false) {
            self.loadingVC.loading(true)
        }
    }
    
    func dismissLoading() {
        guard let vc = loadingVC else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            vc.view.alpha = 0
        }) { _ in
            vc.dismiss(animated: false, completion: {
                self.loadingVC = nil
            })
        }
    }
    
    fileprivate func configWebView(_ config: WKWebViewConfiguration) {
        webView = WKWebView(frame: view.frame, configuration: config)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        let contentController = WKUserContentController();
        contentController.add(
            self,
            name: "emitCertificate"
        )
        
        // 2
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        // 3
        configWebView(config)
        
        // https://sellcreditprod.kubakgroup.com
        // 4
        if let url = URL(string: "https://sellcredit.alpha.kubakbank.com") {
            webView.load(URLRequest(url: url))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    @objc func willResignActive(_ notification: Notification) {
        // code to execute
        UserDefaults.standard.set(true, forKey: "inBackground")
    }
    
    @objc func willTerminate(_ notification: Notification) {
        // code to execute
        UserDefaults.standard.set(false, forKey: "inBackground")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.bringSubview(toFront: loadingView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension WebViewController {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressBar.stopAnimating()
        if UserDefaults.standard.bool(forKey: "inBackground") {
            webView.evaluateJavaScript("lockStatus('true')") { data, error in
                
                if let data = data {
                    print(data)
                }
                
                guard let error = error else {
                    print("lock true")
                    return
                }

                print(error)
            }
        }
        else {
            webView.evaluateJavaScript("lockStatus('false')") { _, error in
                guard let _ = error else {
                    print("lock false")
                    return
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressBar.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressBar.startAnimating()
    }
}

extension WebViewController {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "emitCertificate",
        let dict = message.body as? NSDictionary, let cert = dict["cert"] as? String {
//            UserDefaults.standard.set(cert.data(using: .utf8), forKey: "kbkc_ovpn")
        }
        
        else { print(message.name) }
    }
    
}
