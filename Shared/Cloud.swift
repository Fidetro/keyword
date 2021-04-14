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
import SwiftUI
class Cloud:ObservableObject {
    static let shared = Cloud()
    static let cloud = KVCloud(container: CKContainer(identifier: "iCloud.com.karim.KTCloud"), recordType: "KTCloud")
    static let pasteKey = "Pasteboard"
    @Published var isSyncdb = false
    @Published var isUploaddb = false

    static func sync(string: String, completion completionHandler: @escaping ((_ record:CKRecord?,_ error:Error?)->())) {
        cloud.upsert(key: pasteKey, value: string, completionHandler: completionHandler)
    }
    
    static func pull(completion completionHandler: ((__CKRecordObjCValue?,Error?)->())?=nil) {
        cloud.object(for: pasteKey, completionHandler: completionHandler)
    }
    
    static func syncdb(completion:((_ error: Error?)->())?=nil) {
        shared.isSyncdb = true
        Cloud.cloud.object(for: "database") { (data,error) in
            shared.isSyncdb = false
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
            shared.isSyncdb = true
            let data = try Data(contentsOf: FFDB.share.connection().databasePathURL())
            Cloud.cloud.upsert(key: "database", value: data) { (record, error) in
                debugPrintLog(error)
                shared.isSyncdb = false
                completion?(error)
                
            }
        }catch{
            debugPrintLog(error)
            shared.isSyncdb = false
            completion?(error)
        }
    }
    
}
