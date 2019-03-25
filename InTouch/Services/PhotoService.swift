//
//  PhotoService.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 04.03.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import Foundation
import Alamofire

class PhotoService {
    private let cacheLifeTime: TimeInterval = 30*24*60*60
    private var images = [String: UIImage]()
    private let container: DataReloadable
    
    init<T: DataReloadable>(container: T) {
        self.container = container
    }
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()
    
    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hasheName = String(describing: url.hashValue)
        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hasheName).path
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url) else { return }
        
        let data = image.pngData()
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(url:String) ->UIImage? {
        guard let fileName = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        images[url] = image
        return image
    }
    
    private func loadPhoto(atIndexPath: IndexPath, byUrl url: String) {
        Alamofire.request(url).responseData(queue: DispatchQueue.global()) {
            [weak self] response in
            guard let data = response.data,
                let image = UIImage(data: data),
                let self = self else { return }
            
            self.images[url] = image
            self.saveImageToCache(url: url, image: image)
            
            DispatchQueue.main.async {
                self.container.reloadRow(at: atIndexPath)
            }
        }
    }
    
    public func fetch(byUrl url: String) {
        Alamofire.request(url).responseData(queue: DispatchQueue.global()) {
            [weak self] response in
            guard let data = response.data,
                let image = UIImage(data: data),
                let self = self else { return }
            DispatchQueue.main.async {
                self.images[url] = image
            }
            self.saveImageToCache(url: url, image: image)
        }
    }
    
    public func photo(at indexPath: IndexPath, by urlString: String) -> UIImage? {
        
        if let photo = images[urlString] {
            return photo
        } else if let photo = getImageFromCache(url: urlString) {
            return photo
        } else {
            loadPhoto(atIndexPath: indexPath, byUrl: urlString)
        }
        
        return nil
    }
}
