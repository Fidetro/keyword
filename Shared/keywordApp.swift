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
    }
}
