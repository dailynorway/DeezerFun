//
//  UIImageView+extension.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 10/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func downloadImage(from url: URL) -> URLSessionDataTask? {
        downloadImage(from: url, completed: nil)
    }
    
    func downloadImage(from url: URL, completed: ((Bool) -> Void)?) -> URLSessionDataTask? {
        image = nil
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            completed?(true)
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completed?(true)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                self.image = imageToCache
                completed?(true)
            }
        }
        task.resume()
        return task
    }
}
