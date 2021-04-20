//
//  KVCloud.swift
//  KTCloud
//
//  Created by Fidetro on 2018/10/30.
//  Copyright © 2018 karim. All rights reserved.
//

import Foundation
import CloudKit
import SwiftTool
struct KVCloud {
    let container: CKContainer
    let recordType : String
    init(container: CKContainer?=nil, recordType: String) {
        self.container = container ?? CKContainer.default()
        self.recordType = recordType
    }
    
    func upsert(key:String,
                value:Any? ,
                completionHandler:@escaping ((_ record:CKRecord?,_ error:Error?)->())) {
        
        select { (record, error) in
            if let error = error {
                debugPrintLog(error)
                completionHandler(nil,error)
                return
            }
            
            guard let record = record else {
                let newRecord = CKRecord(recordType: self.recordType)
                newRecord.setValue(value, forKey: key)
                self.container.publicCloudDatabase.save(newRecord, completionHandler: completionHandler)
                self.container.publicCloudDatabase.save(newRecord) { (record, error) in
                    OperationQueue.main.addOperation {
                        if let error = error {
                            debugPrintLog(error)
                        }
                    }
                }
                return
            }
            record.setValue(value, forKey: key)
            self.container.publicCloudDatabase.save(record) { (record, error) in
                OperationQueue.main.addOperation {
                    completionHandler(record,error)
                }
            }
        }
        
        
    }
    
    func select(_ completionHandler: ((_ record:CKRecord?,_ error:Error?)->())?=nil) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        container.publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: {
            (results, error) -> Void in
            debugPrintLog(results?.count)
            assert((results?.count ?? 0)<=1)
            OperationQueue.main.addOperation {
                if let completionHandler = completionHandler {
                    completionHandler(results?.first,error)
                }
            }
        })
    }
    
    func object(for key:CKRecord.FieldKey, completionHandler : ((__CKRecordObjCValue?,Error?)->())?=nil ) {
        select { (record, error) in
            OperationQueue.main.addOperation {                
                if let completionHandler = completionHandler {
                    completionHandler(record?.object(forKey: key),error)
                }
            }
        }
    }
    
}
