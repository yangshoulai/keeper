//
//  Keeper2App.swift
//  Keeper2
//
//  Created by 杨寿来 on 2024/4/1.
//

import SwiftUI

@main
struct KeeperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        //        MenuBarExtra( content: {
        //            ContentView(status: status)
        //        }, label: {
        //            let configuration = NSImage.SymbolConfiguration()
        //                .applying(.init(hierarchicalColor: status.enable ? .white : .lightGray))
        //            let image = NSImage(systemSymbolName: status.enable ? "warninglight.fill" : "warninglight", accessibilityDescription: nil)!
        //            let updateImage = image.withSymbolConfiguration(configuration)!
        //            Image(nsImage: updateImage)
        //
        //        }).menuBarExtraStyle(.window)
        
        Settings{
            
        }
    }
}

class AppDelegate:NSObject ,NSApplicationDelegate {
    @ObservedObject var status = MenuStatusViewModel(assertionManager: AssertionManager())
    
    var aboutWindow: NSWindow!
    
    private var statusItem: NSStatusItem!
    private var popover : NSPopover!
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let statusButton = statusItem.button{
            statusButton.action = #selector(togglePopover)
            changeMenubarIcon()
        }
        self.popover = NSPopover()
        // self.popover.contentSize = NSSize(width: 300, height: 300)
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: ContentView(status: self.status))
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) {
            [weak self] event in
            self?.popover.performClose(event)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(powerStateChanged), name: Notification.Name.NSProcessInfoPowerStateDidChange, object: nil)
        
    }
    
    func terminateLauncherAppIfPossible(){
        for app in NSWorkspace.shared.runningApplications{
            if app.bundleIdentifier == "com.yangshoulai.keeper.LaunchHelper"{
                DistributedNotificationCenter.default().post(name: NSNotification.Name(rawValue: ""), object: Bundle.main.bundleIdentifier)
            }
        }
    }
    
    @objc func togglePopover() {
        if let statusButton = statusItem.button{
            if popover.isShown {
                self.popover.perform(nil)
            }else{
                popover.show(relativeTo: statusButton.bounds, of: statusButton, preferredEdge: NSRectEdge.minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
    
    @objc func powerStateChanged(_ notification: Notification) {
        guard ProcessInfo.processInfo.isLowPowerModeEnabled else { return }
        if status.disableInLowPowerMode {
            status.disableApp()
        }
    }
    
    @objc func openAboutWindow(){
        if nil == aboutWindow {
            aboutWindow = NSWindow()
            aboutWindow.backingType = .buffered
            aboutWindow.styleMask = [.titled, .closable]
            aboutWindow.isReleasedWhenClosed = false
            aboutWindow.contentViewController = NSHostingController(rootView: About())
            aboutWindow.center()
        }
        aboutWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func changeMenubarIcon(){
        
        var img = NSImage(systemSymbolName: status.enable ? "cup.and.saucer.fill" : "cup.and.saucer.fill", accessibilityDescription: nil)
        if !status.enable {
            let conf: NSImage.SymbolConfiguration = NSImage.SymbolConfiguration()
                .applying(.init(hierarchicalColor: .lightGray))
            img = img?.withSymbolConfiguration(conf)!
        }
        if let statusButton = statusItem.button{
            statusButton.image = img
        }
    }
}
