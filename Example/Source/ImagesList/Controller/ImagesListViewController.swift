//
//  ImagesListViewController.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 24/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit
import UniversalDownloader
import ObjectMapper
import UIScrollView_InfiniteScroll
import Lightbox

class ImagesListViewController: UIViewController {
    
    @IBOutlet weak var collImages: UICollectionView!
    @IBOutlet weak var lblNoImages: UILabel!
    @IBOutlet weak var progressView: DotsAnimationView!
    
    private var imagesList: [ImageData] = [ImageData]()
    private var currentPageNo: Int = 0
    private var maxPages: Int = 1
    
    private var refreshControl: UIRefreshControl?
    
}

//MARK: - View lifecycle
extension ImagesListViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        adjustView()
        loadImagesDataFromServer(showProgress: true)
        
    }
    
    private func adjustView() {
        
        collImages.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        //Custom layout
        (collImages.collectionViewLayout as? ColletionViewLayout)?.delegate = self
        
        //Pull to refresh
        refreshControl = UIRefreshControl()
        collImages.alwaysBounceVertical = true
        
        refreshControl?.tintColor = UIColor.black
        refreshControl?.addTarget(self, action: #selector(refreshImagesDataFromServer), for: .valueChanged)
        
        collImages.addSubview(refreshControl!)
        
        //Pagination
        collImages.setShouldShowInfiniteScrollHandler { [weak self] _ -> Bool in
            return self?.currentPageNo ?? 0 < self?.maxPages ?? 0
        }
        
        collImages.addInfiniteScroll { [weak self] (collection) -> Void in
            
            guard let self = self else {
                collection.finishInfiniteScroll()
                return
            }
            
            self.loadImagesDataFromServer(pageNo: self.currentPageNo + 1)
            
        }
        
    }

}

//MARK: - Helpers
extension ImagesListViewController {

    private func setImages(images: [ImageData], pageNo: Int, pagesCount: Int) {
        
        if pageNo == 0 {
            imagesList.removeAll()
        }
        imagesList.append(contentsOf: images)
        
        currentPageNo = pageNo
        maxPages = pagesCount
        
        (collImages.collectionViewLayout as? ColletionViewLayout)?.refreshLayout()
        collImages.reloadData()
        
        lblNoImages.isHidden = !imagesList.isEmpty
        
    }
    
    private func openImage(_ idx: Int) {
        
        guard idx > -1 && idx < imagesList.count else {
            return
        }
        
        let image = imagesList[idx]
        
        guard let imageUrl = URL(string: image.regularUrl) else {
            return
        }
        
        openImageViewer(for: imageUrl)
        
    }
    
    private func openUser(_ idx: Int) {
        
        guard idx > -1 && idx < imagesList.count else {
            return
        }
        
        let image = imagesList[idx]
        
        guard let urlStr = image.user?.profileImageLargeUrl, let imageUrl = URL(string: urlStr) else {
            return
        }
        
        openImageViewer(for: imageUrl)
        
    }
    
    private func openImageViewer(for imageUrl: URL) {
        
        let images = [LightboxImage(imageURL: imageUrl)]
        let imageViewer = LightboxController(images: images)
        
        imageViewer.dynamicBackground = true
        
        present(imageViewer, animated: true, completion: nil)
        
    }
    
}

//MARK: - Data loading
extension ImagesListViewController {
    
    @objc private func refreshImagesDataFromServer() {
        loadImagesDataFromServer(pageNo: 0, showProgress: false)
    }
    
    private func loadImagesDataFromServer(pageNo: Int = 0, showProgress: Bool = false) {
        
        if showProgress {
            progressView.startAnimation()
        }
        
        let url = "\(API_URL.ImageList)\(pageNo)"
        
        UniversalDownloader.shared
            .request(url: url)
            .responseJSON { [weak self] (status, errorMessage, response) in
                
                if showProgress {
                    self?.progressView.stopAnimation()
                }else if pageNo == 0 {
                    self?.refreshControl?.endRefreshing()
                }else {
                    self?.collImages.finishInfiniteScroll()
                }
                
                guard status,
                    let json = response?.array as? [[String : Any]],
                    let images = try? Mapper<ImageData>().mapArray(JSONArray: json) else {
                    
                    let message = errorMessage ?? "Can't get data now. Please try again later."
                    if pageNo == 0 {
                        self?.showAlert(title: "Wait", message: message)
                    }
                    print(message)
                    return
                    
                }
                
                self?.setImages(images: images, pageNo: pageNo, pagesCount: 100)//As server api is not paginated yet so hardcoding maxPages
                
        }
        
    }
    
}

//MARK: - UICollectionview datasource, layout
extension ImagesListViewController: UICollectionViewDataSource, ColletionViewLayoutDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let image = imagesList[indexPath.row]
        
        let itemWidth = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame.width ?? collectionView.frame.width
        
        cell.set(with: image, itemWidth: itemWidth, idx: indexPath.row, imageClickCallback: self.openImage(_:), userClickCallback: self.openUser(_:))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        let image = imagesList[indexPath.row]
        return ImageCell.getHeight(with: image, maxWidth: itemWidth)
        
    }
    
}

