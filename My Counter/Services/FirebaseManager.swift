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

class FirebaseManager {
    func loadTemplate(completionHandler: @escaping ([Template]) -> Void) {
        var templates = [Template]()
        Database.database().reference().child(templateChild).queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { (snapshot) in
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
                          let driveID = item["driveID"] as? String
                    else {
                        print("Error at get templates")
                        continue
                    }
                    let object = Template(id: id, name: name, description: des, imageUrl: imageUrl, dayAdded: day, driveID: driveID)
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
        let storageRef = Storage.storage().reference(forURL: storageUrl).child(template.name ?? "")
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
                                "driveID": template.driveID ?? ""
                            ]
                            Database.database().reference().child(templateChild).child(template.id ?? "").updateChildValues(dict, withCompletionBlock: {
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
    
    func updateHistory(rate: Int, userID: String, day: String) {
        Database.database().reference().child(historyChild).child(userID).child(day).child("rate").setValue(rate)
    }
    func uploadHistory(_ image: UIImage?, name: String?, count: Int = 0, userID: String, day: String) {
        guard let image = image, let name = name else {
            return
        }
        let time = Date.getCurrentDate(withTime: true)
        let storageRef = Storage.storage().reference(forURL: storageUrl).child(time)
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
                            Database.database().reference().child(historyChild).child(userID).child(day).updateChildValues(dict, withCompletionBlock: {
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
    
    func removeTemplate(template: Template, completionHandler: @escaping (CountError?) -> Void) {
        Database.database().reference().child(templateChild).child(template.id ?? "").removeValue() { (error, ref) in
            if error == nil {
                completionHandler(nil)
            }
            else {
                completionHandler(CountError(error))
            }
        }
    }
    
    func loadHistory(completionHandler: @escaping ([CountHistory]?, CountError?) -> Void) {
        var countHistory = [CountHistory]()
        Database.database().reference().child(historyChild).child(AppDelegate.shared().currenUser?.uid ?? "guest").queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { (snapshot) in
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
        Database.database().reference().child(historyChild).child(AppDelegate.shared().currenUser?.uid ?? "guest").child(countHistory?.date ?? "").removeValue { (error, ref) in
            if error == nil {
                completionHandler(nil)
            }
            else {
                completionHandler(CountError(error))
            }
            
        }
    }
    
}
