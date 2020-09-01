//
//  GalleryViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 09/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class GalleryViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelNoPhotos: UILabel!
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    
    let FOOD_BUTTON = 1
    let PARTY_BUTTON = 2
    let FAMILY_BUTTON = 3
    let ALL_BUTTON = 4
    let CELL_ID = "GalleryCell"
    let PAGE_MENU_CELL = "PageMenuCell"
    
    var selectedPageMenu = -1
    var arrayPictureCategory = Array<Dictionary<String, String>>()
    var arrayPictureList = Array<Array<Dictionary<String, String>>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let arrayCartItems = UserDefaultOperations.getArrayObject(ConstantStrings.CART_ITEM_LIST)
        self.setupCartButtonWithBadge(arrayCartItems.count)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = "Gallery"
        self.navigationItem.title = (self.appDelegate.languageData["Gallery"] as? String != nil) ? (self.appDelegate.languageData["Gallery"] as! String).trim() : "Gallery"
        self.labelNoPhotos.text = (self.appDelegate.languageData["NO_PICTURE_UPLOADED_YET"] as? String != nil) ? (self.appDelegate.languageData["NO_PICTURE_UPLOADED_YET"] as! String).trim() : ConstantStrings.NO_PICTURE_UPLOADED_YET
        
        self.setupBackBarButton()
        self.collectionViewCategory.backgroundColor = Colors.colorWithHexString("#E8E8E8")
        self.labelNoPhotos.text = ConstantStrings.NO_PICTURE_UPLOADED_YET
        self.labelNoPhotos.isHidden = true
        self.collectionViewCategory.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        
        self.collectionViewCategory.delegate = self
        self.collectionViewCategory.dataSource = self
        self.collectionViewCategory.register(UINib.init(nibName: "PageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.PAGE_MENU_CELL)
        
        self.webApiGetGalleryPictures()
    }
    
    //    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionViewCategory {
            
            return self.arrayPictureCategory.count
        }else {
            
            if self.arrayPictureList.count > section {
                
                if self.arrayPictureList[self.selectedPageMenu].count == 0 {
                    
                    self.labelNoPhotos.isHidden = false
                }else {
                    
                    self.labelNoPhotos.isHidden = true
                }
                return self.arrayPictureList[self.selectedPageMenu].count
            }else {
                
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! GalleryCollectionViewCell
            
            let arrayPics = self.arrayPictureList[self.selectedPageMenu]
            let dictionaryGallery = arrayPics[indexPath.row]
            var imageUrl = dictionaryGallery[JSONKey.GALLERY_PHOTO_URL]!
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            cell.imageVeiwGallery.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "item"))
            cell.imageVeiwGallery.layer.cornerRadius = 3.0
            cell.imageVeiwGallery.layer.masksToBounds = true
            
            return cell
        }else {
            
            return self.setupPageMenuCell(collectionView, indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionViewCategory {
            
            let label = UILabel(frame: CGRect.zero)
            let dictionaryMenu = self.arrayPictureCategory[indexPath.row]
            label.text = dictionaryMenu[JSONKey.GALLERY_CATEGORY_NAME]
            label.sizeToFit()
            
            return CGSize.init(width: label.frame.width + 10, height: 40)
        }else {
            
            return CGSize.init(width: (self.screenWidth - 30) / 2, height: ((self.screenWidth - 30) / 2))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.collectionViewCategory {
            
            return 0
        }else {
            
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionViewCategory {
            
            self.selectedPageMenu = indexPath.row
            self.collectionViewCategory.reloadData()
            self.collectionViewCategory.scrollToItem(at:IndexPath(item: self.selectedPageMenu, section: 0), at: .right, animated: true)
            
            self.collectionView.reloadData()
        }else {
            
            let arrayPics = self.arrayPictureList[self.selectedPageMenu]
            let previewVC = PreviewViewController.init(nibName: "PreviewViewController", bundle: nil)
            previewVC.arraySliderImage = arrayPics
            previewVC.selectedImage = indexPath.row
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    //    MARK:- Setup Collection View Cell
    func setupPageMenuCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> PageMenuCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.PAGE_MENU_CELL, for: indexPath) as! PageMenuCollectionViewCell
        
        let dictionaryMenu = self.arrayPictureCategory[indexPath.row]
        cell.labelMenuItem.text = dictionaryMenu[JSONKey.GALLERY_CATEGORY_NAME]
        
        if indexPath.row == self.selectedPageMenu {
            
            UtilityMethods.addBorder(cell.viewBg, .white, 8.0)
            cell.viewBg.backgroundColor = Colors.colorWithHexString(Colors.GREEN_COLOR)
            cell.labelMenuItem.textColor = .white
        }else{
            
            cell.viewBg.backgroundColor = .clear
            cell.labelMenuItem.textColor = .black
            UtilityMethods.addBorder(cell.viewBg, .clear, 15.0)
        }
        
        return cell
    }
        
//    MARK:- Web Code Start
//    Web Api for get order tracking information
    func webApiGetGalleryPictures() -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "phpexpert_food_gallery.php?api_key=\(WebApi.API_KEY)&lang_code=\(WebApi.LANGUAGE_CODE)"
        WebApi.webApiForGetRequest(url) { (json : JSON) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                
                if json[JSONKey.ERROR_CODE] == true {
                    
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    
                    self.setupGalleryPhots(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup the gallery image list
    func setupGalleryPhots(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary[JSONKey.GALLERY_LIST] as? Array<Array<Dictionary<String, Any>>> != nil {
            
            let arrayPictures = jsonDictionary[JSONKey.GALLERY_LIST] as! Array<Array<Dictionary<String, Any>>>
            
            if arrayPictures.count > 0 {
                
                let arrayGallery = arrayPictures[0]
                for gallery in arrayGallery {
                    
                    var arrayGalleryPics = Array<Dictionary<String, String>>()
                    var dictionaryCategory = Dictionary<String, String>()
                    dictionaryCategory[JSONKey.GALLERY_CATEGORY_ID] = (gallery[JSONKey.GALLERY_CATEGORY_ID] as? Int != nil) ? (String(gallery[JSONKey.GALLERY_CATEGORY_ID] as! Int)) : "0"
                    dictionaryCategory[JSONKey.GALLERY_CATEGORY_NAME] = (gallery[JSONKey.GALLERY_CATEGORY_NAME] as? String != nil) ? (gallery[JSONKey.GALLERY_CATEGORY_NAME] as! String) : "-"
                    self.arrayPictureCategory.append(dictionaryCategory)
                    
                    if (gallery[JSONKey.GALLERY_PHOTO] as? Array<Dictionary<String, Any>> != nil) {
                        
                        let arrayPhoto = gallery[JSONKey.GALLERY_PHOTO] as! Array<Dictionary<String, Any>>
                        for photo in arrayPhoto {
                            
                            var dictionaryPhoto = Dictionary<String, String>()
                            dictionaryPhoto[JSONKey.GALLERY_PHOTO_ID] = (photo[JSONKey.GALLERY_PHOTO_ID] as? Int != nil) ? (String(photo[JSONKey.GALLERY_PHOTO_ID] as! Int)) : "0"
                            dictionaryPhoto[JSONKey.GALLERY_PHOTO_URL] = (photo[JSONKey.GALLERY_PHOTO_URL] as? String != nil) ? String(photo[JSONKey.GALLERY_PHOTO_URL] as! String) : ""
                            dictionaryPhoto[JSONKey.GALLERY_PHOTO_TITLE] = (photo[JSONKey.GALLERY_PHOTO_TITLE] as? String != nil) ? String(photo[JSONKey.GALLERY_PHOTO_TITLE] as! String) : ""
                            if !dictionaryPhoto.isEmpty {
                                
                                arrayGalleryPics.append(dictionaryPhoto)
                            }
                        }
                    }
                        
                    self.arrayPictureList.append(arrayGalleryPics)
                }
            }
        }else {
            
            self.labelNoPhotos.isHidden = false
        }
        
        if self.arrayPictureCategory.count == 0 {
            
            self.labelNoPhotos.isHidden = false
        }else {
            
            self.selectedPageMenu = 0
            self.labelNoPhotos.isHidden = true
            self.collectionView.reloadData()
            self.collectionViewCategory.reloadData()
        }
    }
}

