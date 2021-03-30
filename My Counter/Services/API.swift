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
    func uploadForCounting(image: UIImage, template: Template, method: CountMethod = .defaultMethod, completionHandler: @escaping (CountRespone) -> Void) {
        let parameters = [
            "name": template.name,
            "id": template.id,
            "method": method.rawValue
        ]
        print(parameters)
        
        let img = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        let imgData = img.jpegData(compressionQuality: 1)!
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        }
        },
        to:apiUrl, method: .post)
        .responseDecodable(of: CountRespone.self) { resp in
            if let countResponse = resp.value {
                completionHandler(countResponse)
            }
            else {
                completionHandler(CountRespone(count: 0, url: "", fileName: ""))
            }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }

}

