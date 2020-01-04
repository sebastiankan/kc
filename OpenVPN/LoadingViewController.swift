//
//  LoadingViewController.swift
//  Kubak Credit
//
//  Created by Farid on 9/8/19.
//  Copyright © 2019 Kubak. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    var visualEffectView = VisualEffectView(frame: .zero)
    let loadingView: UIView = UIView()
    let loading = ActivityIndicatorView()
    let loadingLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading(false)
        setupStyle()
        setupLayout()
        
        view.backgroundColor = .white
    }
    
    func setupStyle() {

        loading.isAnimating = true
        loading.usesLargerStyle = true
        loading.tintColor = UIColor(hexString: "#5D7588")
        
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = UIColor(hexString: "#5A5D60")
        loadingLabel.font = UIFont(name: "IRANYekanMobile", size: 18)
        let attributedString2 = NSMutableAttributedString(string: "در حـال اتصال\n لطفا منتظر بمانید...")
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineSpacing = 5
        paragraphStyle2.alignment = NSTextAlignment.center
        attributedString2.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle2, range:NSMakeRange(0, attributedString2.length))
        loadingLabel.attributedText = attributedString2
    }
    
    func setupLayout() {
        setupVisualEffectView()
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loadingView.addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loadingView.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.topAnchor.constraint(equalTo: loading.bottomAnchor, constant: 28).isActive = true
        loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setupVisualEffectView() {
        visualEffectView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        visualEffectView.colorTint = .white
        visualEffectView.colorTintAlpha = 0.5
        visualEffectView.blurRadius = 10
        visualEffectView.scale = 15
        
        loadingView.insertSubview(visualEffectView, at: 0)
    }
    
    func loading(_ status: Bool) {
        if status {
            self.loadingView.alpha = 1
        } else {
            self.loadingView.alpha = 0
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
