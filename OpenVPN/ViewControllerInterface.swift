//
//  ViewControllerInterface.swift
//  Kubak Credit
//
//  Created by Farid on 9/7/19.
//  Copyright © 2019 Kubak. All rights reserved.
//

import UIKit

class ViewControllerInterface: UIViewController {
    
    let imageView: UIImageView = UIImageView(image: UIImage(named: "question"))
    let label: UILabel = UILabel()
    let allowButton: UIButton = UIButton()
    let denyButton: UIButton = UIButton()
    
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
        label.numberOfLines = 0
        label.textColor = UIColor(hexString: "#5A5D60")
        label.font = UIFont(name: "IRANYekanMobile", size: 18)
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: "بۆ ئەوەی کوباک بە دروستی کار بکات پێویستە رێگەی پێ بدرێت بە vpnە وە ببەسترێتەوە")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = NSTextAlignment.center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        
        allowButton.backgroundColor = UIColor(hexString: "#6E88EB")
        allowButton.layer.shadowColor = UIColor(hexString: "#6E88EB").cgColor
        allowButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        allowButton.layer.shadowOpacity = 1.0
        allowButton.layer.shadowRadius = 4.0
        allowButton.layer.masksToBounds = false
        allowButton.layer.cornerRadius = 24.0
        allowButton.setTitle("ڕێگە دەدەم", for: .normal)
        allowButton.addTarget(self, action: #selector(animateButton), for: .touchUpInside)
        allowButton.titleLabel?.font = UIFont(name: "IRANYekanMobile-Bold", size: 18)
        
        denyButton.setTitle("ڕێگە نادەم", for: .normal)
        denyButton.setTitleColor(UIColor(hexString: "#5A5D60"), for: .normal)
        denyButton.titleLabel?.font = UIFont(name: "IRANYekanMobile", size: 16)
        
        loading.isAnimating = true
        loading.usesLargerStyle = true
        loading.tintColor = UIColor(hexString: "#5D7588")
        
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = UIColor(hexString: "#5A5D60")
        loadingLabel.font = UIFont(name: "IRANYekanMobile", size: 18)
        let attributedString2 = NSMutableAttributedString(string: "باركردن...")
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineSpacing = 5
        paragraphStyle2.alignment = NSTextAlignment.center
        attributedString2.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString2.length))
        loadingLabel.attributedText = attributedString2
    }
    
    func setupLayout() {
        setupVisualEffectView()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -imageView.frame.height / 2).isActive = true
        imageView.centerXAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor).isActive = true
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64).isActive = true
        
        view.addSubview(allowButton)
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        allowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        allowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        allowButton.widthAnchor.constraint(equalToConstant: 245).isActive = true
        allowButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(denyButton)
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        denyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        denyButton.widthAnchor.constraint(equalToConstant: 245).isActive = true
        denyButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
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
    
    @objc func animateButton() {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.allowButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.allowButton.transform = CGAffineTransform.identity
                        }
        })
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
