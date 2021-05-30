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
import SocketIO

class API {
    let firebaseManagere = FirebaseManager()
    
    let manager = SocketManager(socketURL: URL(string: CountRequest.count)!, config: [.log(true), .compress])
    var socket: SocketIOClient?

    init() {
        socket = manager.defaultSocket
        connectSocket()
    }
    
    func connectSocket() {
        self.socket!.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        self.socket!.connect()
    }
    
    
    func add(id: String, name: String, driveID: String) {
        let parameters = [
            "id": id,
            "name": name,
            "driveID": driveID
        ]
        
        AF.request(CountRequest.add, method: .post, parameters: parameters)
            .responseJSON { (respone) in
                print(respone)
            }
    }
    
    func prepare(id: String, completionHandler: @escaping (BaseResponse) -> Void) {
        let parameters = [
            "id": id
        ]
        print(parameters)
        AF.request(CountRequest.prepare, method: .post, parameters: parameters)
            .responseJSON { (response) in
                print(response)
            }
    }
    
    
    func count(image: UIImage, template: TemplateServer, advanced: Bool = false, completionHandler: @escaping (BoxResponse?, CountError?) -> Void) {
        let parameters = [
            "name": template.name,
            "id": template.id,
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
        to:CountRequest.count, method: .post)
        .responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(CommonResponse.self, from: data)
                        if result.success {
                            let countResponse = try JSONDecoder().decode(BoxResponse.self, from: data)
                            completionHandler(countResponse, nil)
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
}



