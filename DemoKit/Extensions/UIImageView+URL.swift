//
//  UIImageView+URL.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-26.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

extension UIImageView {
    
    ///
    /// Cache
    ///
    struct ImageCache {
        static private var cache = NSCache<AnyObject, AnyObject>()
        
        static func image(forURL url: String) -> UIImage? {
            return cache.object(forKey: url as AnyObject) as? UIImage ?? nil
        }
        
        static func cacheImage(_ image: UIImage, forURL url: String) {
            cache.setObject(image, forKey: url as AnyObject)
        }
        
        static func clear() {
            cache.removeAllObjects()
        }
    }
    
    ///
    /// Load from url
    ///
    @discardableResult
    func loadFrom(url urlString: String, animated: Bool = true) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        // fetch from cache...
        if let cachedImage = ImageCache.image(forURL: urlString) {
            setImage(cachedImage, animated: false)
            return nil
        }
        
        // ... or download Image
        let task =
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let imageToCache = UIImage(data: data) {
                    ImageCache.cacheImage(imageToCache, forURL: urlString)
                    self.setImage(imageToCache, animated: animated)
                }
            }
        }
        task.resume()
        return task
    }
    
    ///
    /// Sets the UIImage with fade animation
    ///
    func setImage(_ image: UIImage, animated: Bool = true) {
        self.alpha = animated ? 0.0 : 1.0
        
        UIView.animate(withDuration: animated ? 0.5 : 0.0) {
            self.image = image
            self.alpha = 1.0
        }
    }
}
