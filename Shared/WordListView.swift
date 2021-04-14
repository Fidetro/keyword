//
//  WordListView.swift
//  keyword
//
//  Created by Fidetro on 2021/4/11.
//

import SwiftUI

struct WordListView: View {
    @ObservedObject var manager = WordManager.shared
    
    var body: some View {
        List {
            ForEach(manager.words,id: \.self) { word in
                HStack{
                    if let en_name = word.en_name {
                        Text(en_name)
                    }
                    
                    if let zh_name = word.zh_name {
                        Text(zh_name)
                    }
                }.contextMenu {
                    Button(action: {
                        delete(at: word)
                    }) {
                        Text("删除")
                    }
                }
            }.onDelete(perform: delete)
        }.listStyle(PlainListStyle())
        
        
    }
    func delete(at offsets: IndexSet) {
        offsets.forEach{ index in
            let word = manager.words[index]
            word.delete()
            manager.words.remove(at: index)
            Cloud.uploadDB()
        }
    }
    func delete(at word: Word) {        
        if let index = manager.words.firstIndex(of: word) {
            word.delete()
            manager.words.remove(at: index)
            Cloud.uploadDB()
        }
    }

}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView()
    }
}

