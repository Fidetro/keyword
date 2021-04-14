//
//  NavigationBarView.swift
//  keyword
//
//  Created by Fidetro on 2021/4/10.
//

import SwiftUI
fileprivate struct DialogTitle {
    static var shared = DialogTitle()
    var promptTitle = ""
}
struct NavigationBarView<Content: View>: View {
  
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    @State private var showingInputAlert = false
    @State private var showingSyncToast = false
    @State private var showingUploadToast = false
    @State var en_name: String? = nil
    @State var zh_name: String? = nil
    var body: some View {
        NavigationView {
            VStack{
                content.ignoresSafeArea()
                    .navigationTitle("单词本")
                    .navigationSetting()
                    .toolbar {
                        ToolbarItem(direction: .left) {
                        Label("", systemImage: "arrow.clockwise.icloud.fill")
                            .foregroundColor(.white)
                            .onTapGesture {
                                Cloud.syncdb { (error) in
                                    showingSyncToast = true
                                    if let error = error {
                                        DialogTitle.shared.promptTitle = "\(error)"
                                    } else {
                                        DialogTitle.shared.promptTitle = "同步成功"
                                    }
                                    WordManager.shared.fetch()
                                }
                            }
                            .sheet(isPresented: $showingSyncToast) {
                                Dialog(prompt: DialogTitle.shared.promptTitle)
                            }
                        }
                        ToolbarItem(direction: .right) {
                            Label("", systemImage: "icloud.and.arrow.up.fill")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    Cloud.uploadDB { (error) in
                                        showingUploadToast = true
                                        if let error = error {
                                            DialogTitle.shared.promptTitle = "\(error)"
                                        } else {
                                            DialogTitle.shared.promptTitle = "上传成功"
                                        }
                                    }
                                }
                                .sheet(isPresented: $showingUploadToast) {
                                    Dialog(prompt: DialogTitle.shared.promptTitle)
                                }
                        }
                        ToolbarItem(direction: .right) {
                                                       
                            Label("", systemImage: "plus.rectangle.fill")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    showingInputAlert = true
                                }.sheet(isPresented: $showingInputAlert) {
                                    InputDialog(prompt:  "输入单词" , value1: $en_name, value2: $zh_name)
                                }.onChange(of: [en_name,zh_name]) { (array) in
                                    let word = Word()
                                    word.en_name = en_name
                                    word.zh_name = zh_name
                                    word.insert()
                                    WordManager.shared.fetch()
                                    Cloud.uploadDB { (error) in
                                    }
                                }
                        }
                    }.foregroundColor(.white)
                    .ignoresSafeArea()
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

