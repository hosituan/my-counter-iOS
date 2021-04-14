//
//  API.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftUI
class API {
    let firebaseManagere = FirebaseManager()
    func uploadImage(image: UIImage, template: TemplateServer, advanced: Bool = false, completionHandler: @escaping (UploadResponse?, CountError?) -> Void) {
        let parameters = [
            "name": template.name,
            "id": template.id
        ]
        print(parameters)
        var img = image
        print(image.size)
        if !advanced {
            if (image.size.width < 1000 || image.size.height < 1000) {
                img = image.resizeImage(targetSize: CGSize(width: 1000, height: 1000))
            }
        }
        
        let imgData = img.jpegData(compressionQuality: 1)!
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value!.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
        to:CountRequest.upload, method: .post)
        .responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(CommonResponse.self, from: data)
                        if result.success {
                            let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
                            completionHandler(uploadResponse, nil)
                        }
                        else {
                            let error = CountError(reason: result.message)
                            completionHandler(nil, error)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        let error = CountError(error)
                        completionHandler(nil, error)
                    }
                }
            case .failure(let error):
                let error = CountError(error)
                completionHandler(nil, error)
            }
        })
    }
    
    func requestCount(imageName: String, template: TemplateServer, showConfidence: Bool = false, completionHandler: @escaping (CountResponse?, CountError?) -> Void) {
        let con: Int = showConfidence ? 0 : 1
        let parameters = [
            "imageName": imageName,
            "id": template.id ?? "",
            "name": template.name ?? "default",
            "showConfidence": con
        ] as [String : Any]
        AF.request(CountRequest.count, method: .post, parameters: parameters)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    if let data = response.data {
                        do {
                            let result = try JSONDecoder().decode(CommonResponse.self, from: data)
                            if result.success {
                                let countRespone = try JSONDecoder().decode(CountResponse.self, from: data)
                                completionHandler(countRespone, nil)
                            }
                            else {
                                let error = CountError(reason: result.message)
                                completionHandler(nil, error)
                            }
                        } catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                            let error = CountError(error)
                            completionHandler(nil, error)
                        }
                    }
                case .failure(let error):
                    let error = CountError(error)
                    completionHandler(nil, error)
                }
                
            })
    }
}



