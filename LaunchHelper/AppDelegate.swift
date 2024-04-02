//
//  AppDelegate.swift
//  LaunchHelper
//
//  Created by 杨寿来 on 2024/4/2.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow!
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let mainAppIdentifier = "com.yangshoulai.keeper"
        var mainAppRunning = false
        for app in NSWorkspace.shared.runningApplications{
            if app.bundleIdentifier == mainAppIdentifier{
                mainAppRunning = true
                break
            }
        }
        if !mainAppRunning{
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(terminate), name: NSNotification.Name(rawValue: ""), object: "mainAppIdentifier")
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainAppIdentifier) else {
                print("main app with identifier \(mainAppIdentifier) not found")
                return
            }
            let conf = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.openApplication(at: url, configuration: conf)
        } else {
            NSApp.terminate(nil)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @objc func terminate(){
        NSApp.terminate(nil)
    }
    
    
}

