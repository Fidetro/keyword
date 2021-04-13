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
                }
            }.onDelete(perform: delete)
        }.listStyle(PlainListStyle())
        
        
    }
    func delete(at offsets: IndexSet) {
        manager.words.remove(atOffsets: offsets)
        
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView()
    }
}

