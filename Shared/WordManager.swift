//
//  WordManager.swift
//  keyword
//
//  Created by Fidetro on 2021/4/11.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

class WordManager: NSObject,ObservableObject {
    static let shared = WordManager()
    @Published var words = [Word]()
    func fetch() {
        if let array = Word.select() as? [Word] {
            words = array
        }
    }
    
}
