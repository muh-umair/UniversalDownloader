//
//  Extensions.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(withColor color: UIColor = .black, offset: CGSize = .zero, radius: CGFloat = 3, opacity: Float = 0.5) {
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        
    }
    
    func addBorder(withColor color: UIColor, width: CGFloat) {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        
    }
    
    func setCornerRadius(radius: CGFloat = 5, masksToBounds: Bool = true) {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = masksToBounds
        
    }
    
}

extension String {
    
    func calculateSize(withFont font: UIFont, textColor: UIColor, maxWidth: CGFloat, maxHeight: CGFloat, textAlignment: NSTextAlignment) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let str = NSAttributedString(string: self, attributes: attributes)
        let maxSize = CGSize(width: maxWidth, height: maxHeight)
        return str.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        
    }
    
}

extension UIViewController {
    
    func showAlert(title: String, message: String, firstOptionTitle: String = "OK", firstOptionCallback: (()->Void)? = nil, secondOptionTitle: String? = nil, secondOptionCallback: (()->Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstOptionTitle, style: .default, handler: { _ in
            firstOptionCallback?()
        })
        alert.addAction(firstAction)
        
        if secondOptionTitle != nil {
            let secondAction = UIAlertAction(title: secondOptionTitle!, style: .default) { _ in
                secondOptionCallback?()
            }
            alert.addAction(secondAction)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension UIColor {
    
    func isLight(threshold: Float = 0.5) -> Bool? {
        let originalCGColor = self.cgColor
        
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
        
    }
}
