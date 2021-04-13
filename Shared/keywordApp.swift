//
//  keywordApp.swift
//  Shared
//
//  Created by Fidetro on 2021/4/8.
//

import SwiftUI
import SwiftFFDB
#if os(macOS)
class AppDelegate: BaseAppDelegate, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        applicationLaunch()
    }
    
}
#else
class AppDelegate: BaseAppDelegate, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        applicationLaunch()
        return true
    }
}
#endif
class BaseAppDelegate : NSObject {
    func applicationLaunch() {
        Word.registerTable()
        WordManager.shared.fetch()
        Cloud.syncdb { (error) in
            WordManager.shared.fetch()
        }
    }
}
@main
struct keywordApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    var body: some Scene {
        WindowGroup {
            NavigationBarView.init {
                WordListView()
            }
            
            }
            //            Text("插入").onTapGesture {
            //               var obj = TestObject()
            //                obj.name = "测试"
            //                obj.insert()
            //                print("插入")
            //            }
            //            Text("查询").padding().onTapGesture {
            //
            //                print("查询 \(TestObject.select())")
            //            }
            //            Text("拉").onTapGesture {
            //                print("拉")
            //                Cloud.cloud.object(for: "database") { (data) in
            //
            //                    print(FFDB.share.connection().databasePathURL())
            //                    if let data = data as? Data {
            //                        do{
            //                        try data.write(to: FFDB.share.connection().databasePathURL())
            //                        }catch{
            //                            print(error)
            //                        }
            //                    }
            //                }
            //            }
            //            Text("推").onTapGesture {
            //                print("推")
            //                do{
            //                   let data = try Data(contentsOf: FFDB.share.connection().databasePathURL())
            //
            //                    Cloud.cloud.upsert(key: "database", value: data) { (record, error) in
            //                        print(error)
            //                    }
            //                }catch{
            //                    print(error)
            //                }
            //
            //            }
    }
}
