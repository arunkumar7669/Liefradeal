//
//  PreviewViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 09/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class PreviewViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let CELL_ID = "PreviewCell"
    var selectedImage = Int()
    var arraySliderImage = Array<Dictionary<String, String>>()
//    var arraySliderImage = ["splash1", "splash2", "splash3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func setupViewDidLoadMethod() {
        
        self.navigationItem.title = (self.appDelegate.languageData["Preview"] as? String != nil) ? (self.appDelegate.languageData["Preview"] as! String).trim() : "Preview"
        self.setupBackBarButton()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "PreviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.collectionView.scrollToItem(at:IndexPath(item: self.selectedImage, section: 0), at: .right, animated: false)
        }
    }
    
//    MARK:- UICollectionView Delegate And Datasource method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arraySliderImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! PreviewCollectionViewCell
        
        let dictionaryGallery = self.arraySliderImage[indexPath.row]
        var imageUrl = dictionaryGallery[JSONKey.GALLERY_PHOTO_URL]!
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.imageViewPreview.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: ""))
        self.setupSingleTapGestureOnImage(cell)
        self.setupDoubleTapGestureOnImage(cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           if let iPath = collectionView?.indexPathsForVisibleItems.first {
               print("DidEndDecelerating - visible cell is: ", iPath)
               // do what you want here...
            let cell = collectionView!.cellForItem(at: iPath) as! PreviewCollectionViewCell
            cell.scrollView.zoomScale = 1.0
           }
       }
    
    func setupSingleTapGestureOnImage(_ cell : PreviewCollectionViewCell) -> Void {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.imageViewPreview.isUserInteractionEnabled = true
        cell.imageViewPreview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    var isHiddenNavigationBar = Bool()
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if self.isHiddenNavigationBar {
            
            self.isHiddenNavigationBar = false
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }else {
            
            self.isHiddenNavigationBar = true
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
//    Setup Double tab for
    func setupDoubleTapGestureOnImage(_ cell : PreviewCollectionViewCell) -> Void {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        cell.imageViewPreview.isUserInteractionEnabled = true
        cell.imageViewPreview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageDoubleTapped(tapGestureRecognizer: UITapGestureRecognizer) {
            
        let pageWidth = self.collectionView.frame.size.width
        let currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
        let indexPath = IndexPath.init(row: currentPage, section: 0)
        let cell = collectionView!.cellForItem(at: indexPath) as! PreviewCollectionViewCell
        cell.scrollView.zoomScale = 1.0
    }
}
