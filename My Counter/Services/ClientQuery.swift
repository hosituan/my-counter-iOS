//
//  ClientQuery.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 08/06/2021.
//

import Foundation
import Parse

// MARK: - ClientQuery

class ClientQuery: NSObject {
    
    internal class func callFunctionInBackground(_ function: String, withParameters parameters: [AnyHashable: Any]?, block: PFIdResultBlock?) {
        print("api",function)
        PFCloud.callFunction(inBackground: function, withParameters: parameters) { (object, error) in
            block?(object, error)
            
            handleError(error)
        }
    }
    
    internal class func getFirstObjectInBackgroundMatchedQuery(_ query: PFQuery<PFObject>, resultBlock block: PFObjectResultBlock?) {
        query.getFirstObjectInBackground { (object, error) in
            block?(object, error)
            handleError(error)
        }
    }
    
    internal class func findObjectsInBackgroundMatchedQuery(_ query: PFQuery<PFObject>, resultBlock block: PFArrayResultBlock?) {
        query.findObjectsInBackground { (objects, error) in
            block?(objects, error)
            handleError(error)
        }
    }
    
    internal class func findObjectsInBackgroundMatchedQuery2(_ query: PFQuery<PFObject>, resultBlock block: @escaping (([PFObject]?, Error?) -> Void?)) {
        query.findObjectsInBackground { (objects, error) in
            block(objects, error)
            handleError(error)
        }
    }
    
    internal class func countObjectsMatchedQuery(query: PFQuery<PFObject>, resultBlock block: PFIntegerResultBlock?) {
        query.countObjectsInBackground { (result, error) in
            block?(result, error)
            handleError(error)
        }
    }
    
    internal class func removeObjectsMatchedQuery(query: PFQuery<PFObject>) {
        query.findObjectsInBackground { (objects, error) in
            if let deletingObjects = objects {
                for deletingObject in deletingObjects {
                    deletingObject.deleteInBackground()
                }
            }
            handleError(error)
        }
    }
    
    internal class func handleError(_ error: Error?) {
        guard let errorCast = error as NSError? else {
            return
        }
        guard errorCast.domain == PFParseErrorDomain else {
            return
        }
        
        switch errorCast.code {
        case PFErrorCode.errorInvalidSessionToken.rawValue:
            handleInvalidSessionTokenError()
            return
            
        case PFErrorCode.errorConnectionFailed.rawValue:
            handleConnectionFailedError()
            return
            
        default:
            return
        }
        
    }
    
    internal class func handleInvalidSessionTokenError() {
        NotificationCenter.default.post(
            Notification(name: Notification.Name(rawValue: NotificationMessage.invalidSessionToken.rawValue),
                         object: "SessionIsExpiredStr"))
    }
    
    internal class func handleUnauthenticatedError() {
        NotificationCenter.default.post(
            Notification(name: Notification.Name(rawValue: NotificationMessage.unauthenticationError.rawValue),
                         object: nil))
        
    }
    
    internal class func handleConnectionFailedError() {
        NotificationCenter.default.post(
            Notification(name: Notification.Name(rawValue: NotificationMessage.connectionFailed.rawValue),
                         object: nil))
    }
    
    
}

enum NotificationMessage: String {
    case connectionFailed = "kConnectionFailed"
    case unauthenticationError = "kUnauthenticationError"
    case invalidSessionToken = "kInvalidSessionToken"
    case reloadProfilePage = "kReloadProfilePage"
    case inactivePresident = "kInactivePresident"
    case showSectionInHome = "kShowSectionInHome"
    case hideSectionInHome = "kHideSectionInHome"
}
