//
//  ImageCell.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit
import UniversalDownloader

typealias CellClickCallback = (Int)->Void

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var contContent: UIView!
    @IBOutlet weak var contShadow: UIView!
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var constImgImageHeight: NSLayoutConstraint!
    
    private var idx: Int?
    private var imageClickCallback: CellClickCallback?
    private var userClickCallback: CellClickCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contShadow.addShadow(offset: CGSize(width: 2, height: 2), radius: 3, opacity: 0.3)
        contShadow.setCornerRadius(masksToBounds: false)
        contContent.setCornerRadius()
        
    }
    
    func set(with data: ImageData, itemWidth: CGFloat, idx: Int, imageClickCallback: @escaping CellClickCallback, userClickCallback: @escaping CellClickCallback) {
        
        //Set view with data
        contContent.backgroundColor = data.color
        lblUserName.textColor = (data.color.isLight() ?? true) ? UIColor.black : UIColor.white
        
        UniversalDownloader.shared
            .request(url: data.smallUrl)
            .responseImage(in: imgImage, placeholder: #imageLiteral(resourceName: "image_placeholder"), failure: nil)
        
        UniversalDownloader.shared
            .request(url: data.user?.profileImageSmallUrl ?? "")
            .responseImage(in: imgUser, placeholder: #imageLiteral(resourceName: "user_placeholder"), failure: nil)
        
        lblUserName.text = data.user?.name ?? ""
        
        constImgImageHeight.constant = CGFloat(data.height) / CGFloat(data.width) * (itemWidth - 8)
        
        //Keep ref for callbacks
        self.idx = idx
        self.imageClickCallback = imageClickCallback
        self.userClickCallback = userClickCallback
        
    }
    
}

//MARK: - Helper to calculate height
extension ImageCell {
    
    static func getHeight(with data: ImageData, maxWidth: CGFloat) -> CGFloat {
        
        let labelMaxWidth = maxWidth - 8 - 46//8 padding on container, 30 profile image, 16 inner paddings
        
        var height = (data.user?.name ?? "").calculateSize(withFont: UIFont.systemFont(ofSize: 16), textColor: .black, maxWidth: labelMaxWidth, maxHeight: CGFloat.greatestFiniteMagnitude, textAlignment: .left).height
        
        height = max(height, 30)//Label has min height of 30
        
        height += CGFloat(data.height) / CGFloat(data.width) * maxWidth
        
        height += 16 //Vertical padding between different views
        
        return height
        
    }
    
}

//MARK: - Actions
extension ImageCell {
    
    @IBAction func actImage() {
        
        if let idx = idx, let callback = imageClickCallback {
            callback(idx)
        }
        
    }
    
    @IBAction func actUser() {
        
        if let idx = idx, let callback = userClickCallback {
            callback(idx)
        }
        
    }
    
}
