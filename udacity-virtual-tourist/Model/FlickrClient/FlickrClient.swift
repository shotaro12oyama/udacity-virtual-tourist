//
//  FlickrClient.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/07.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation

class FlickrClient {
    
    static let apiKey = "9e9d1f8cb303c0ae25e22fcaab02e522"

    struct PhotoDownload {
        static var lat: Double = 0.0
        static var lon: Double = 0.0
        static var photoURL: [String?] = []
    }
    
    
    enum Endpoints {
        static let base =  "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList"
        static let apiKeyParam = "&api_key=\(FlickrClient.apiKey)"
        
        case getPhotolist
        
        var stringValue: String {
            switch self {
            case .getPhotolist: return Endpoints.base + Endpoints.apiKeyParam + "&format=json&nojsoncallback=1"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    
    class func getPhotolist(completion: @escaping ([PhotoInfo], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getPhotolist.url, responseType: FlickrResponse.self) { response, error in
            if let response = response {
                completion(response.photos.photo, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getPhotoDownloadInfo (photoInfo: [PhotoInfo], completion: @escaping (Bool, Error?) -> Void)  {
        for item in photoInfo {
            let url = "https://farm\(item.farm).staticflickr.com/\(item.server)/\(item.id)_\(item.secret)_s.jpg"
            PhotoDownload.photoURL.append(url)
        }
        
    }
    
    /*
    class func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }*/
    
}


