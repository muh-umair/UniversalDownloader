//
//  DotsAnimationView.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 26/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

@IBDesignable
class DotsAnimationView: UIView {
    
    @IBInspectable var dotsCount: Int = 3
    @IBInspectable var dotsColor: UIColor = .white
    @IBInspectable var dotsDiameter: CGFloat = 16
    @IBInspectable var dotsSpacing: CGFloat = 8
    
    private func creatDots() {
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        var dotX = (self.frame.width - (CGFloat(dotsCount) * dotsDiameter) - (CGFloat(dotsCount - 1) * dotsSpacing)) / 2
        let dotY = (self.frame.height - dotsDiameter) / 2
        
        (0..<dotsCount).forEach { _ in
            
            let dotView = UIView(frame: CGRect(x: dotX, y: dotY, width: dotsDiameter, height: dotsDiameter))
            dotView.backgroundColor = dotsColor
            dotView.setCornerRadius(radius: dotsDiameter / 2)
            
            self.addSubview(dotView)
            dotX += dotsDiameter + dotsSpacing
            
        }
        
    }
    
    private func animateWithKeyframes(dotToAnimate: UIView, delay: Double) {
        UIView.animateKeyframes(
            withDuration: 0.9,
            delay: delay,
            options: [UIView.KeyframeAnimationOptions.repeat],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.33333333333,
                    animations: {
                        dotToAnimate.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.33333333333,
                    relativeDuration: 0.66666666667,
                    animations: {
                        dotToAnimate.transform = CGAffineTransform.identity
                }
                )
        }
        )
    }
    
}

extension DotsAnimationView {
    
    func stopAnimation() {
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
    }
    
    func startAnimation() {
        
        creatDots()
        
        let delays = [0.0, 0.3, 0.6]
        (0..<self.subviews.count).forEach { (idx) in
            animateWithKeyframes(dotToAnimate: self.subviews[idx], delay: delays[idx % delays.count])
        }
        
    }
    
}
