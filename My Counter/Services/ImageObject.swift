//
//  ImageObject.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 08/06/2021.
//

import Foundation
import Parse

// MARK: - ParseImage

class ImageObject: PFObject, PFSubclassing {
    
    @NSManaged var file: PFFileObject?
    @NSManaged var thumbSmall: PFFileObject?
    @NSManaged var thumbMedium: PFFileObject?
    @NSManaged var thumbLarge: PFFileObject?
    @NSManaged var type: String?
    @NSManaged var name: String?
    
    static func parseClassName() -> String {
        return "Image"
    }
    
    static func makeFile(_ image: UIImage) -> Any? {
        let data = image.pngData()!
        do {
            let file = try PFFileObject(name: "countImage", data: data, contentType: "image/jpeg")
            return file
        } catch let e as NSError {
            return e
        }
    }
    
}
