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
    func loadTemplate(completionHandler: @escaping ([TemplateServer]) -> Void) {
        var templates = [TemplateServer]()
        Database.database().reference().child(templateChild).queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                
                let values = dataArray.map { $0.1 }
                for dict in values {
                    let item = dict as! NSDictionary
                    
                    guard let name = item["name"] as? String,
                          let id = item["id"] as? String,
                          let imageUrl = item["imageURL"] as? String,
                          let des = item["description"] as? String
                    else {
                        print("Error at get templates")
                        continue
                    }
                    let object = TemplateServer(id: id, name: name, description: des, imageUrl: imageUrl)
                    templates.append(object)
                }
                
            }
            completionHandler(templates)
            
        }) { (error) in
            print(error.localizedDescription)
            completionHandler(templates)
        }
    }
    
    func uploadTemplate(template: Template, completionHandler: @escaping (Error?) -> Void) {
        
        let storageRef = Storage.storage().reference(forURL: storageUrl).child(template.name)
        let metadata = StorageMetadata()
        if let imageData = template.image.jpegData(compressionQuality: 1.0) {
            metadata.contentType = "image/jpg"
            print(metadata)
            print(imageData)
            //upload image to firebase storage
            storageRef.putData(imageData, metadata: metadata, completion: {
                (StorageMetadata, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(error)
                    return
                }
                else {
                    storageRef.downloadURL(completion: {
                        (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            let dict: Dictionary<String, Any>  = [
                                "name": template.name,
                                "imageURL": metaImageUrl,
                                "id": template.id,
                                "description" : template.description
                            ]
                            Database.database().reference().child(templateChild).child(template.id).updateChildValues(dict, withCompletionBlock: {
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

}
