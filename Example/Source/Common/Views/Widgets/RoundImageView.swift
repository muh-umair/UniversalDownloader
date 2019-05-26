//
//  RoundImageView.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 26/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        initHelper()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initHelper()
        
    }
    
    private func initHelper() {
        
        self.setCornerRadius(radius: frame.height / 2)
        
    }
    
}
