//
//  MenuStatusViewModel.swift
//  Keeper2
//
//  Created by 杨寿来 on 2024/4/1.
//

import Foundation
import ServiceManagement
import SwiftUI

class MenuStatusViewModel : ObservableObject {
    let launchAppIdentifier = "com.yangshoulai.keeper.launcher"
    
    @Published var enable = false
    
    @Published var autoStartup = false
    
    @Published var duration = 30
    
    @Published var allowDisplaySleep = false
    
    @Published var disableInLowPowerMode = false
    
    var assertionManager:AssertionManager
    
    init(assertionManager: AssertionManager){
        self.assertionManager = assertionManager
        load()
    }
    
    public  func load() -> Void {
        self.enable = false
        self.autoStartup = UserDefaults.standard.bool(forKey: "keeper.autoStartup")
        self.duration = UserDefaults.standard.integer(forKey: "keeper.duration")
        self.allowDisplaySleep = UserDefaults.standard.bool(forKey: "keeper.allowDisplaySleep")
        self.disableInLowPowerMode = UserDefaults.standard.bool(forKey: "keeper.disableInLowPowerMode")
    }
    
    public  func store() -> Void {
        UserDefaults.standard.setValue(self.autoStartup, forKey: "keeper.autoStartup")
        UserDefaults.standard.setValue(self.duration, forKey: "keeper.duration")
        UserDefaults.standard.setValue(self.allowDisplaySleep, forKey: "keeper.allowDisplaySleep")
        UserDefaults.standard.setValue(self.disableInLowPowerMode, forKey: "keeper.disableInLowPowerMode")
    }
    
    public func enableApp(){
        self.enable = assertionManager.create(timeout: Double(self.duration > 0 ? self.duration * 60 : Int.max), allowDisplaySleep:  self.allowDisplaySleep)
        store()
    }
    
    public func disableApp(){
        self.enable = !assertionManager.clear()
        store()
    }
    
    public func enableAutoStartup(){
        self.autoStartup = addLoginItem()
        store()
    }
    
    public func disableAutoStartup(){
        self.autoStartup = !removeLoginItem()
        store()
    }
    
    public func setDuration(_ d: Int){
        self.duration = d
        if self.enable {
            enableApp()
        }
        store()
    }
    
    public func enableAllowDisplaySleep(){
        if self.enable {
            enableApp()
        }
        store()
    }
    
    public func disableAllowDisplaySleep(){
        if self.enable {
            enableApp()
        }
        store()
    }
    

    private func addLoginItem() -> Bool{
        if #available(macOS 13.0, *){
            do {
                try SMAppService.mainApp.register()
                return true
            }catch {
                print(error.localizedDescription)
            }
            
        }else{
            return SMLoginItemSetEnabled(launchAppIdentifier as CFString,  true)
        }
        return false
    }
    
    private func removeLoginItem() -> Bool{
        if #available(macOS 13.0, *){
            do {
                try SMAppService.mainApp.unregister()
                return true
            }catch {
                print(error.localizedDescription)
            }
        }else{
            return SMLoginItemSetEnabled(launchAppIdentifier as CFString,  false)
        }
        
        return false
    }
}
