//
//  PhotoStore.swift
//  Photorama
//
//  Created by Pankova Mariya on 25.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum PhotoError: Error {
    case ImageCreationError
}

class PhotoStore {
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
        
    }()
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processRecentPhotoRequest(data: data, response: response, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processRecentPhotoRequest(data: Data?, response: URLResponse?, error: Error?) -> PhotosResult {
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
            return .Failure(error!)
        }
        printKeyData(response: httpResponse)
        
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(data: jsonData)
    }
    
    func fetchImageForPhoto(photo: Photo, completion: @escaping (ImageResult) -> Void) {
        if let image = photo.image {
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, response: response, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
            }
            completion(result)
        }
        task.resume()
    }
    
    func processImageRequest(data: Data?, response: URLResponse?, error: Error?) -> ImageResult {
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
            return .Failure(error!)
        }
        printKeyData(response: httpResponse)
        
        guard let
            imageData = data,
            let image = UIImage(data: imageData) else {
                if data == nil {
                    return .Failure(error!)
                } else {
                    return .Failure(PhotoError.ImageCreationError)
                }
        }
        return .Success(image)
    }
    
    func printKeyData(response: HTTPURLResponse) {
        print(response.statusCode)
        print(response.allHeaderFields)
    }
}
