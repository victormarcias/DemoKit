//
//  UIImageView+URL.swift
//  GenericKit
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
    func loadFrom(url urlString: String, animated: Bool = true) {
        guard let url = URL(string: urlString) else { return }
        
        // fetch from cache...
        if let cachedImage = ImageCache.image(forURL: urlString) {
            setImage(cachedImage, animated: false)
            return
        }
        
        // ... or download Image
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let imageToCache = UIImage(data: data) {
                    ImageCache.cacheImage(imageToCache, forURL: urlString)
                    self.setImage(imageToCache, animated: animated)
                }
            }
        }.resume()
    }
    
    func setImage(_ image: UIImage, animated: Bool = true) {
        self.alpha = animated ? 0.0 : 1.0
        
        UIView.animate(withDuration: animated ? 0.5 : 0.0) {
            self.image = image
            self.alpha = 1.0
        }
    }
}
