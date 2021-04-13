//
//  Cloud.swift
//  KTCloud
//
//  Created by Fidetro on 2018/10/30.
//  Copyright © 2018 karim. All rights reserved.
//

import Foundation
import CloudKit
import SwiftFFDB
import SwiftTool
struct Cloud {
    static let cloud = KVCloud(container: CKContainer(identifier: "iCloud.com.karim.KTCloud"), recordType: "KTCloud")
    static let pasteKey = "Pasteboard"
    
    static func sync(string: String, completion completionHandler: @escaping ((_ record:CKRecord?,_ error:Error?)->())) {
        cloud.upsert(key: pasteKey, value: string, completionHandler: completionHandler)
    }
    
    static func pull(completion completionHandler: ((__CKRecordObjCValue?,Error?)->())?=nil) {
        cloud.object(for: pasteKey, completionHandler: completionHandler)
    }
    
    static func syncdb(completion:((_ error: Error?)->())?=nil) {
        Cloud.cloud.object(for: "database") { (data,error) in
            print(FFDB.share.connection().databasePathURL())
            if let data = data as? Data {
                do{
                    try data.write(to: FFDB.share.connection().databasePathURL())
                    completion?(error)
                }catch{
                    debugPrintLog(error)
                    completion?(error)
                }
            } else {
                completion?(error)
            }
        }
    }
    
    static func uploadDB(completion:((_ error: Error?)->())?=nil) {
        do{
            let data = try Data(contentsOf: FFDB.share.connection().databasePathURL())
            
            Cloud.cloud.upsert(key: "database", value: data) { (record, error) in
                debugPrintLog(error)
                completion?(error)
            }
        }catch{
            debugPrintLog(error)
            completion?(error)
        }
    }
    
}
