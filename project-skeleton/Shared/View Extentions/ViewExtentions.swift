//
//  Spinner.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 03.04.2021.
//

import UIKit

extension UIView {
    static let loadingViewTag = 1
    
    /// Show loading indicator on some view
    func showLoading() {
        var loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        if loading == nil {
            loading = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        }
        // Setup label for loading indicator
        let loadingLabel = UILabel()
        setupUI(for: loadingLabel)
       
        // Setup loading indicator
        loading!.startAnimating()
        loading!.hidesWhenStopped = true
        loading?.tag = UIView.loadingViewTag
        
        // Add to view
        loading!.addSubview(loadingLabel)
        addSubview(loading!)
        
        // Setup constraints
        [loading, loadingLabel].forEach{$0?.translatesAutoresizingMaskIntoConstraints = false}
        // Setup constraints for loading
        loading?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        // Setup constraints for  label
        loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingLabel.topAnchor.constraint(equalTo: loading!.bottomAnchor, constant: 20).isActive = true
    }
    
    /// Stop loading indicator and remove from superview
    func stopLoading() {
        let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        loading?.stopAnimating()
        loading?.removeFromSuperview()
    }
    
    /// Setup ui for lavel
    /// - Parameter label: accept some label
    func setupUI(for label: UILabel) {
        label.text = "Loading ..."
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        label.textColor = .label
    }
}

extension UIView {
    /// Add blur effect to some view
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

extension UIView {
  
  /// Remove UIBlurEffect from UIView
  func removeBlurEffect() {
    let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
    blurredEffectViews.forEach{ blurView in
      blurView.removeFromSuperview()
    }
  }
}

extension UIView {
    
    /// Setup shadow for some view
    /// - Returns: shadowed view
    func setupShadowFor(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
}


extension UIView {
    
    // Animation functions
    func pulse() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 3
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
    
}

