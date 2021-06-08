//
//  FirebaseManager.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase
import TLPhotoPicker

struct Firebase {
    private static let storageUrl = "gs://my-counter-c02e5.appspot.com"
    private static let templateChild = "Template"
    private static let historyChild = "History"
    private static let proposeChild = "Propose"
    
    static let idLength = 5
    
    static let templateReference = Database.database().reference().child(templateChild)
    static let historyReference = Database.database().reference().child(historyChild)
    static let proposeReference = Database.database().reference().child(proposeChild)
    static let storageReference = Storage.storage().reference(forURL: storageUrl)
}

class FirebaseManager {
    //MARK: -- Template
    func loadTemplate(completionHandler: @escaping ([Template]) -> Void) {
        var templates = [Template]()
        Firebase.templateReference.queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                let values = dataArray.map { $0.1 }
                for dict in values {
                    let item = dict as! NSDictionary
                    guard let name = item["name"] as? String,
                          let id = item["id"] as? String,
                          let imageUrl = item["imageURL"] as? String,
                          let des = item["description"] as? String,
                          let day = item["day"] as? String,
                          let driveID = item["driveID"] as? String,
                          let isCircle = item["isCircle"] as? Bool
                    else {
                        print("Error at get templates")
                        continue
                    }
                    let object = Template(id: id, name: name, description: des, imageUrl: imageUrl, dayAdded: day, driveID: driveID, isCircle: isCircle)
                    templates.append(object)
                }
                
            }
            templates.sort {
                $0.dayAdded ?? "" > $1.dayAdded ?? ""
            }
            
            completionHandler(templates)
            
        }) { (error) in
            print(error.localizedDescription)
            completionHandler(templates)
        }
    }
    
    func uploadTemplate(template: Template, image: UIImage, completionHandler: @escaping (CountError?) -> Void) {
        let time = Date.getCurrentDate(withTime: true)
        let storageRef = Firebase.storageReference.child(template.name ?? "")
        let metadata = StorageMetadata()
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            metadata.contentType = "image/jpg"
            print(metadata)
            print(imageData)
            //upload image to firebase storage
            storageRef.putData(imageData, metadata: metadata, completion: {
                (StorageMetadata, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(CountError(error))
                    return
                }
                else {
                    storageRef.downloadURL(completion: {
                        (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            let dict: Dictionary<String, Any>  = [
                                "name": template.name ?? "",
                                "imageURL": metaImageUrl,
                                "id": template.id ?? "",
                                "day": time,
                                "description" : template.description ?? "",
                                "driveID": template.driveID ?? "",
                                "isCircle": template.isCircle ?? true
                            ]
                            Firebase.templateReference.child(template.id ?? "").updateChildValues(dict, withCompletionBlock: {
                                (error, ref) in
                                if error == nil {
                                    print("Uploaded template.")
                                    completionHandler(nil)
                                }
                            })
                            
                        }
                    })
                }
            })
        }
        
    }
    
    func removeTemplate(template: Template, completionHandler: @escaping (CountError?) -> Void) {
        Firebase.templateReference.child(template.id ?? "").removeValue() { (error, ref) in
            if error == nil {
                completionHandler(nil)
            }
            else {
                completionHandler(CountError(error))
            }
        }
    }
    
    func proposeTemplate(name: String?, description: String?, images: [TLPHAsset]?, completionHandler: @escaping (CountError?) -> Void) {
        let date = Date()
        guard let description = description, let name = name, let images = images else {
            return
        }
        
        let dict: Dictionary<String, Any>  = [
            "name": name,
            "description": description
        ]
        
        Firebase.proposeReference.child(AppDelegate.shared().currenUser?.uid ?? "guest").child(date.toString()).setValue(dict)
        
        var imageDict: Dictionary<String, Any>  = [:]
        for image in images {
            if let img = image.fullResolutionImage{
                uploadImage(image: img) { (url) in
                    if let url = url {
                        imageDict[url] = 0
                        Firebase.proposeReference.child(AppDelegate.shared().currenUser?.uid ?? "guest").child(date.toString()).child("imageURLs").setValue(imageDict)
                    }
                    else {
                        completionHandler(CountError(reason: "Can't upload image"))
                    }
                    
                }
            }
        }
    }
    
    func uploadImage(image: UIImage, completionHandler: @escaping (String?) -> Void) {
        let storageRef = Firebase.storageReference.child(Date().toString())
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageRef.putData(imageData, metadata: metaData) { (StorageMetadata, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(nil)
                }
                else {
                    storageRef.downloadURL(completion: {
                        (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            completionHandler(metaImageUrl)
                        }
                        else {
                            completionHandler(nil)
                        }
                    })
                }
            }
        }
    }
    
    //MARK: -- History
    
    func updateHistory(rate: Int, userID: String, day: String) {
        Firebase.historyReference.child(userID).child(day).child("rate").setValue(rate)
    }
    func uploadHistory(_ image: UIImage?, name: String?, count: Int = 0, userID: String, day: String) {
        guard let image = image, let name = name else {
            return
        }
        let time = Date.getCurrentDate(withTime: true)
        let storageRef = Firebase.storageReference.child(time)
        let metadata = StorageMetadata()
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            metadata.contentType = "image/jpg"
            //upload image to firebase storage
            storageRef.putData(imageData, metadata: metadata, completion: {
                (StorageMetadata, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                else {
                    storageRef.downloadURL(completion: {
                        (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            let dict: Dictionary<String, Any>  = [
                                "count": count,
                                "name": name,
                                "imageURL": metaImageUrl,
                                "day": time,
                                "rate": 0
                            ]
                            Firebase.historyReference.child(userID).child(day).updateChildValues(dict, withCompletionBlock: {
                                (error, ref) in
                                if error == nil {
                                    print("Uploaded response")
                                }
                            })
                            
                        }
                    })
                }
            })
        }
    }
    
    func loadHistory(completionHandler: @escaping ([CountHistory]?, CountError?) -> Void) {
        var countHistory = [CountHistory]()
        Firebase.historyReference.child(AppDelegate.shared().currenUser?.uid ?? "guest").queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                
                let values = dataArray.map { $0.1 }
                for dict in values {
                    if let item = dict as? NSDictionary {
                        
                        guard let name = item["name"] as? String,
                              let imageUrl = item["imageURL"] as? String,
                              let day = item["day"] as? String,
                              let count = item["count"] as? Int,
                              let rate = item["rate"] as? Int
                        else {
                            print("Error at get history")
                            continue
                        }
                        let object = CountHistory(date: day, url: imageUrl, name: name, count: count, rate: rate)
                        countHistory.append(object)
                    }
                }
                
            }
            countHistory.sort {
                $0.date > $1.date
            }
            
            completionHandler(countHistory, nil)
            
        }) { (error) in
            print(error.localizedDescription)
            completionHandler(nil, CountError(error))
        }
    }
    
    func removeHistory(countHistory: CountHistory?, completionHandler: @escaping ((CountError?) -> Void)) {
        Firebase.historyReference.child(AppDelegate.shared().currenUser?.uid ?? "guest").child(countHistory?.date ?? "").removeValue { (error, ref) in
            if error == nil {
                completionHandler(nil)
            }
            else {
                completionHandler(CountError(error))
            }
            
        }
    }
    
}

