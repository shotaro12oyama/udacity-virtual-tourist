//
//  PhotoAlbumCollectionViewCell.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/06.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var progressBar: UIProgressView!
    
    func configure(imageURL: URL, downloaded: Bool, download: Download?) {
        
        // Download controls are Pause/Resume, Cancel buttons, progress info
        var showDownloadControls = false
        // Non-nil Download object means a download is in progress
        if let download = download {
            showDownloadControls = true
            let title = download.isDownloading ? "Pause" : "Resume"
        }

        progressBar.isHidden = !showDownloadControls
        
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
        progressBar.progress = progress
    }

}
