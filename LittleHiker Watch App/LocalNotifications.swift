//
//  LocalNotifications.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/23/24.
//

import Foundation
import UserNotifications

final class LocalNotifications: NSObject, ObservableObject {
    
    private let categoryIdentifier = "custom"
    private let actionIdentifier = "notiAction"
    
    
    func register() async throws {
        let current = UNUserNotificationCenter.current()
        try await current.requestAuthorization(options: [.alert, .sound])
        //이전에 나가려고 했던 pending된 Notification 다 지우기
        current.removeAllPendingNotificationRequests()
        
        let action = UNNotificationAction(identifier: actionIdentifier,
                                          title: "닫기",
                                          options : .foreground)
        let category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: [action],
                                              intentIdentifiers: [])
        
        current.setNotificationCategories([category])
        current.delegate = self
    }
    
    func schedule() {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .sound]) {[weak self] granted, error in
            guard let self = self else { return }
            
            if granted {
                print("허용되었습니다")
                let content = UNMutableNotificationContent()
                content.title = "잠깐"
                content.subtitle = "다람이 missing"
                content.body = "다람이가 못따라오고 있어요"
                content.categoryIdentifier = self.categoryIdentifier
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: trigger)
                current.add(request)
            } else {
                print("로컬 알림 권한이 허용되지 않았습니다")
            }
            
        }
    }
}

extension LocalNotifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.list, .sound]
    }

}
