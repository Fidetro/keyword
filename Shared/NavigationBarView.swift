//
//  NavigationBarView.swift
//  keyword
//
//  Created by Fidetro on 2021/4/10.
//

import SwiftUI

fileprivate enum Sheets: Identifiable {
    var id: Int {
        self.hashValue
    }
    
    case input
    case sync
    case upload
}

fileprivate struct DialogTitle {
    static var shared = DialogTitle()
    var promptTitle = ""
}
struct NavigationBarView<Content: View>: View {
//    @ObservedObject var cloud = Cloud.shared

    @State fileprivate var sheet :Sheets?
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

//    @State private var syncdb_img = "arrow.clockwise.icloud.fill"
    @State var en_name: String? = nil
    @State var zh_name: String? = nil
    let itemWith = CGFloat(40)
    var body: some View {
        NavigationView {
            VStack{
                content.ignoresSafeArea()
                    .navigationTitle("单词本")
                    .navigationSetting()
                    .toolbar {
                        leftSyncItem()
                        rightUploadItem()
                        rightAddItem()
                    }.foregroundColor(.white)
                    .ignoresSafeArea()
            }.sheet(item: $sheet) { item in
                switch item {
                case .input:
                    InputDialog(prompt:  "输入单词" , value1: $en_name, value2: $zh_name)
                case .upload:
                    Dialog(prompt: DialogTitle.shared.promptTitle)
                case .sync:
                    Dialog(prompt: DialogTitle.shared.promptTitle)
                }
            }
        }
    }
    func leftSyncItem() -> some ToolbarContent {
        ToolbarItem(direction: .left) {
        Label("", systemImage: "arrow.clockwise.icloud.fill")
            .foregroundColor(.white)
            .frame(width: itemWith, height: 30, alignment: .center)
//                            .onChange(of: cloud.isSyncdb, perform: { (isSyncdb) in
//                                if isSyncdb {
//                                    syncdb_img = "icloud.and.arrow.up.fill"
//                                } else {
//                                    syncdb_img = "arrow.clockwise.icloud.fill"
//                                }
//                            })
            .onTapGesture {
                Cloud.syncdb { (error) in
                    sheet = .sync
                    if let error = error {
                        DialogTitle.shared.promptTitle = "\(error)"
                    } else {
                        DialogTitle.shared.promptTitle = "同步成功"
                    }
                    
                    WordManager.shared.fetch()
                }
            }
        }
    }
    func rightUploadItem() -> some ToolbarContent {
        ToolbarItem(direction: .right) {
            Label("", systemImage: "icloud.and.arrow.up.fill")
                .foregroundColor(.white)
                .frame(width: itemWith, height: 30, alignment: .center)
                .onTapGesture {
                    Cloud.uploadDB { (error) in
                        sheet = .upload
                        if let error = error {
                            DialogTitle.shared.promptTitle = "\(error)"
                        } else {
                            DialogTitle.shared.promptTitle = "上传成功"
                        }
                    }
                }
        }
    }
    func rightAddItem() -> some ToolbarContent {
        return ToolbarItem(direction: .right) {
            Label("", systemImage: "plus.rectangle.fill")
                .foregroundColor(.white)
                .frame(width: itemWith, height: 30, alignment: .center)
                .onTapGesture {
                    sheet = .input
                }.onChange(of: en_name) { [en_name] newState in
                    if let newState = newState,
                       Word.select(where: "en_name = ?", values: [newState]) == nil {
                        print(newState)
                        let word = Word()
                        word.en_name = newState
                        word.zh_name = zh_name
                        word.insert()
                        WordManager.shared.fetch()
                        Cloud.uploadDB { (error) in
                        }
                    }
                }
        }
    }

}

extension View {
    func navigationSetting() -> some View {
        #if os(macOS)
        return self
        #else        
        return self.navigationBarTitleDisplayMode(.large)
        #endif
    }
}

extension ToolbarItem where ID == Void {
    public enum Direction {
        case left
        case right
    }
    public init(direction: Direction, @ViewBuilder content: () -> Content) {
        #if os(macOS)
        self.init(placement: .navigation,content: content)
        #else
        self.init(placement: direction == .left ? .navigationBarLeading : .navigationBarTrailing,content: content)
        #endif
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView.init {
            
        }
    }
}

