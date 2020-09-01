//
//  PreviewCollectionViewCell.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 10/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var imageViewPreview: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageViewPreview
    }
}
