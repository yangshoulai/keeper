//
//  ContentView.swift
//  Keeper2
//
//  Created by 杨寿来 on 2024/4/1.
//

var durations: [Duration] = [
    Duration(label: "无限期", minutes: 0),
    Duration(label: "15 分钟", minutes:  15),
    Duration(label: "30 分钟", minutes: 30),
    Duration(label: "45 分钟", minutes: 45),
    Duration(label: "1 小时", minutes: 60),
    Duration(label: "2 小时", minutes: 120),
    Duration(label: "4 小时", minutes: 240),
    Duration(label: "8 小时", minutes: 480),
    Duration(label: "12 小时", minutes: 720),
    Duration(label: "24 小时", minutes: 1440)
]

func formatDate(_ duration: Int) -> String{
    if duration <= 0 {
        return "无限期"
    }
    let date = Date().addingTimeInterval(Double(duration * 60))
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateformatter.string(for: date)!
}

import SwiftUI
import ServiceManagement

import Cocoa
import IOKit.pwr_mgt
struct ContentView: View {
    
    @ObservedObject var status :MenuStatusViewModel
    
    @State var c : Color = Color.gray.opacity(1)
    
    var assertionManager : AssertionManager = AssertionManager()
    
    @State var durationEnd: String = ""
    
    var body: some View {
        
        ZStack(alignment: .topLeading){
            
            VStack(alignment: .leading, spacing: 4){
                MenuItem(){HStack{
                    VStack(alignment: .leading){
                        Text("启用")
                            .font(.callout)
                            .fontWeight(.bold)
                        if status.enable{
                            Text("活动至 \(durationEnd)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    Toggle(isOn: $status.enable) {
                        Text("")
                    }.toggleStyle(.switch).onChange(of: status.enable){
                        newValue in
                        if newValue{
                            durationEnd = formatDate(status.duration)
                            status.enableApp()
                        }else {
                            durationEnd = ""
                            status.disableApp()
                        }
                        NSApp.sendAction(#selector(AppDelegate.changeMenubarIcon), to: nil, from: nil)
                    }.controlSize(.small)
                }
                }
                
                MenuItem(){
                    HStack{
                        Text("持续时间") .font(.callout)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Picker("", selection: $status.duration){
                            ForEach(durations, id: \.minutes){
                                d in
                                Text(d.label).tag(d.minutes)
                            }
                        }.frame(width: 100).onChange(of: status.duration){
                            n in
                            status.setDuration(n)
                            if status.enable {
                                durationEnd = formatDate(status.duration)
                            }
                        }
                    }
                }
                
                
                
                Divider()
                
                MenuItem(){HStack{
                    Text("允许屏幕休眠")
                        .font(.callout)
                        .fontWeight(.bold)
                    Spacer()
                    Toggle(isOn: $status.allowDisplaySleep) {
                        Text("")
                    }.toggleStyle(.switch).onChange(of: status.allowDisplaySleep){
                         n in
                        if n {
                            status.enableAllowDisplaySleep()
                        }else{
                            status.disableAllowDisplaySleep()
                        }
                    }.controlSize(.small)
                }}
                
                MenuItem(){HStack{
                    Text("低电量自动停用")
                        .font(.callout)
                        .fontWeight(.bold)
                    Spacer()
                    Toggle(isOn: $status.disableInLowPowerMode) {
                        Text("")
                    }.toggleStyle(.switch).onChange(of: status.disableInLowPowerMode){
                       n in
                        status.store()
                    }.controlSize(.small)
                }}
                
                MenuItem(){HStack{
                    Text("开机自动启动")
                        .font(.callout)
                        .fontWeight(.bold)
                    Spacer()
                    Toggle(isOn: $status.autoStartup) {
                        Text("")
                    }.toggleStyle(.switch).onChange(of: status.autoStartup){
                         n in
                        if n {
                            status.enableAutoStartup()
                        }else{
                            status.disableAutoStartup()
                        }
                    }.controlSize(.small)
                }}
                
                Divider()
                VStack(spacing: 0){
                    MenuItem(action: {
                        // openWindow(id : "about")
                        NSApp.sendAction(#selector(AppDelegate.openAboutWindow), to: nil, from: nil)
                    }){
                        HStack{
                            Text("关于")  .font(.callout)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    
                    MenuItem(action: {
                        _ = assertionManager.clear()
                        NSApplication.shared.terminate(nil)
                    }){
                        HStack{
                            Text("退出")  .font(.callout)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
                
                
            }.padding(6)
        }.frame(width: 220,  alignment: .topLeading)
    }
    
}
