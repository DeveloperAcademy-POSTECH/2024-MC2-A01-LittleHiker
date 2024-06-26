//
//  LocalNotifications.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/23/24.
//

import Foundation
import UserNotifications
import WatchKit

final class LocalNotifications: NSObject, ObservableObject {
    private let categoryIdentifier = "custom"
    private let actionIdentifier = "notiAction"
    @Published var tipsBlockCount: Int = 0
    @Published var isTipsBlocked: Bool = false
    @Published var warningBlockCount: Int = 0
    @Published var isTipsBlockLocked: Bool = false
    
//    func register() async throws {
//        let current = UNUserNotificationCenter.current()
//        try await current.requestAuthorization(options: [.alert, .sound])
//        //이전에 나가려고 했던 pending된 Notification 다 지우기
//        current.removeAllPendingNotificationRequests()
//        
//        let action = UNNotificationAction(identifier: actionIdentifier,
//                                          title: "닫기",
//                                          options : .foreground)
//        let category = UNNotificationCategory(identifier: categoryIdentifier,
//                                              actions: [action],
//                                              intentIdentifiers: [])
//        
//        current.setNotificationCategories([category])
//        current.delegate = self
//    }
    
    func schedule() {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .sound]) {[weak self] granted, error in
            guard let self = self else { return }
            
            if granted {
                print("허용되었습니다")
                if tipsBlockCount != 0 { return }
                if isTipsBlocked == true { return }
                tipsBlockCount += 10
                current.removeAllPendingNotificationRequests()
                let content = UNMutableNotificationContent()
                content.title = "잠깐"
                content.subtitle = "다람상식"
                content.body = "하산시에는 체중의 4.9배의 충격이 가해진다는 연구 결과가 있어요!"
                content.categoryIdentifier = "다람상식"
                
//                let trigger: UNTimeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                //UserNoitificationAppDelegate에 나머지 설정 있음
                let action1 = UNNotificationAction(identifier:"30분_끄기",
                                                  title: "30분동안 다람상식 끄기",
                                                  options: [])
                let action2 = UNNotificationAction(identifier: "계속_끄기",
                                                  title: "계속 다람상식 끄기",
                                                  options: [])
                let category = UNNotificationCategory(identifier: "다람상식",
                                                      actions: [action1, action2],
                                                      intentIdentifiers: [],
                                                      options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category])
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: nil)
                
                DispatchQueue.global().async{
                    current.add(request)
                }

//                }
            } else {
                print("로컬 알림 권한이 허용되지 않았습니다")
            }
        }
    }
    
    
    func schedule2() {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .sound]) {[weak self] granted, error in
            guard let self = self else { return }
            
            if granted {
                if warningBlockCount != 0 { return }
                warningBlockCount += 15
                current.removeAllPendingNotificationRequests()
                print("허용되었습니다")
                let content = UNMutableNotificationContent()
                content.title = "잠깐"
                content.subtitle = "다람이 missing"
                content.body = "다람이가 못따라오고 있어요."
                content.categoryIdentifier = self.categoryIdentifier
                
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: nil)
                DispatchQueue.global().async{
                    current.add(request)
                }

            } else {
                print("로컬 알림 권한이 허용되지 않았습니다")
            }
            
        }
    }
    
    func triggerHapticFeedback() {
        WKInterfaceDevice.current().play(.notification)
    }
    
    func turnOffTipsFor30Minutes(){
        isTipsBlocked = true
        tipsBlockCount = 60*30
        print("turnOffFor30Minutes")
    }
    
    func turnOffTips(){
        isTipsBlocked = true
        isTipsBlockLocked = true
    }
    
    
    func decreaseTipsBlockCount(){
        if tipsBlockCount > 0 {
            tipsBlockCount -= 0
        }
        if tipsBlockCount == 0 && !isTipsBlockLocked {
            self.turnOnTips()
        }
    }

    
    func turnOnTips(){
        tipsBlockCount = 0
        isTipsBlocked = false
        isTipsBlockLocked = false
    }
    
    
    func decreaseWarningBlockCount(){
        if warningBlockCount > 0 {
            tipsBlockCount -= 0
       }
    }
    
    func toggleTipsManually(){
        if isTipsBlockLocked {
            isTipsBlockLocked = false
            isTipsBlocked = false
            tipsBlockCount = 0
        }
        
        else {
            isTipsBlockLocked = true
            isTipsBlocked = true
        }
    }
    
    func toggleTipsLock(){
        isTipsBlockLocked = !isTipsBlockLocked
    }
}
