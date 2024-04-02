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
    
    @Published var enable = false
    
    @Published var autoStartup = false
    
    @Published var duration = 30
    
    var assertionManager:AssertionManager
    
    
    init(assertionManager: AssertionManager){
        self.assertionManager = assertionManager
        load()
        if self.autoStartup != (SMAppService.mainApp.status == .enabled){
            self.autoStartup = SMAppService.mainApp.status == .enabled
            store()
        }
    }
    
    public  func load() -> Void {
        self.enable = false
        self.autoStartup = UserDefaults.standard.bool(forKey: "keeper.autoStartup")
        self.duration = UserDefaults.standard.integer(forKey: "keeper.duration")
    }
    
    public  func store() -> Void {
        UserDefaults.standard.setValue(self.autoStartup, forKey: "keeper.autoStartup")
        UserDefaults.standard.setValue(self.duration, forKey: "keeper.duration")
    }
    
    public func enableApp(){
        self.enable = assertionManager.create(timeout: Double(self.duration > 0 ? self.duration * 60 : Int.max))
        store()
    }
    
    public func disableApp(){
        self.enable = !assertionManager.clear()
        store()
    }
    
    public func enableAutoStartup(){
        let enabled = SMAppService.mainApp.status == .enabled
        if !enabled{
            do {
                try SMAppService.mainApp.register()
            } catch {
                print(error.localizedDescription)
            }
        }
        self.autoStartup = SMAppService.mainApp.status == .enabled
        store()
    }
    
    public func disableAutoStartup(){
        let enabled = SMAppService.mainApp.status == .enabled
        if enabled{
            do {
                try SMAppService.mainApp.unregister()
            } catch {
                print(error.localizedDescription)
            }
        }
        self.autoStartup = SMAppService.mainApp.status == .enabled
        store()
    }
    
    public func setDuration(_ d: Int){
        self.duration = d
        if self.enable {
            self.enable =  assertionManager.create(timeout: Double(self.duration > 0 ? self.duration * 60 : Int.max))
        }
        store()
    }
    
    
}
