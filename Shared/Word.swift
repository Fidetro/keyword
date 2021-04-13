//
//  Word.swift
//  keyword
//
//  Created by Fidetro on 2021/4/11.
//
#if os(macOS)
import Cocoa
#else
import UIKit
#endif
import SwiftFFDB

class Word: NSObject,FFObject {
    
    var primaryId : Int64?
    
    var en_name : String?
    var zh_name : String?
    
    required override init() {
        
    }
    
    static func ignoreProperties() -> [String]? {
        return nil
    }
    
    static func customColumnsType() -> [String : String]? {
        return nil
    }
    
    static func customColumns() -> [String : String]? {
        return nil
    }
    
    static func primaryKeyColumn() -> String {
        return "primaryId"
    }
}
