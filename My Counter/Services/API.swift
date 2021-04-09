//
//  API.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import Foundation
import UIKit
import Alamofire

class API {
    
    func uploadImage(image: UIImage, template: TemplateServer, completionHandler: @escaping (UploadRespone?, Error?) -> Void) {
        let parameters = [
            "name": template.name,
            "id": template.id
        ]
        print(parameters)
        
        let img = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000))
        let imgData = img.jpegData(compressionQuality: 1)!
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value!.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
        to:apiUrl + Request.upload.rawValue, method: .post)
        .responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(CommonRespone.self, from: data)
                        if result.success {
                            let uploadResponse = try JSONDecoder().decode(UploadRespone.self, from: data)
                            completionHandler(uploadResponse, nil)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        completionHandler(nil, error)
                    }
                }
            case .failure(let error):
                completionHandler(nil, error)
            }
        })
    }
    
    func requestCount(imageName: String, template: TemplateServer, completionHandler: @escaping (CountRespone?, Error?) -> Void) {
        let parameters = [
            "imageName": imageName,
            "id": template.id,
            "name": template.name
        ]
        AF.request(apiUrl + Request.count.rawValue, method: .post, parameters: parameters)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    if let data = response.data {
                        do {
                            let result = try JSONDecoder().decode(CommonRespone.self, from: data)
                            if result.success {
                                let countRespone = try JSONDecoder().decode(CountRespone.self, from: data)
                                completionHandler(countRespone, nil)
                            }
                        } catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                            completionHandler(nil, error)
                        }
                    }
                case .failure(let error):
                    completionHandler(nil, error)
                }
                
            })
    }
}

