//
//  DownloadService.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/12.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {
    
    // SearchViewController creates downloadsSession
    var downloadsSession: URLSession!
    var activeDownloads: [URL: Download] = [:]
    
    // MARK: - Download methods called by TrackCell delegate methods
    
    func startDownload(_ flickrImage: FlickrImage) {
        let download = Download(flickrImage: flickrImage)
        download.task = downloadsSession.downloadTask(with: flickrImage.imageURL)
        download.task!.resume()
        download.isDownloading = true
        activeDownloads[download.flickrImage.imageURL] = download
    }
    
    func pauseDownload(_ flickrImage: FlickrImage) {
        guard let download = activeDownloads[flickrImage.imageURL] else { return }
        if download.isDownloading {
            download.task?.cancel(byProducingResumeData: { data in
                download.resumeData = data
            })
            download.isDownloading = false
        }
    }
    
    func cancelDownload(_ flickrImage: FlickrImage) {
        if let download = activeDownloads[flickrImage.imageURL] {
            download.task?.cancel()
            activeDownloads[flickrImage.imageURL] = nil
        }
    }
    
    func resumeDownload(_ flickrImage: FlickrImage) {
        guard let download = activeDownloads[flickrImage.imageURL] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: flickrImage.imageURL)
        }
        download.task!.resume()
        download.isDownloading = true
    }
    
}
