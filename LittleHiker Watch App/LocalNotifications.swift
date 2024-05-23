//
//  LocalNotifications.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/23/24.
//

import Foundation
import UserNotifications

final class LocalNotifications: NSObject {
    
    private let categoryIdentifier = "custom"
    private let actionIdentifier = "notiAction"
    
    override init(){
        super.init()
        
        Task{
            do {
                try await register()
                try await schedule()
                
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    private func register() async throws {
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
    
    func schedule() async throws {
        let current = UNUserNotificationCenter.current()
        let settings = await current.notificationSettings()
        
        //notification setting이 enabled 되어 있을 때만 schedule을 할 수 있음. 아니면 schedule 자체가 의미 없음
        guard settings.alertSetting == .enabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "잠깐"
        content.subtitle = "다람이 missing"
        content.body = "다람이가 못따라오고 있어요"
        content.categoryIdentifier = categoryIdentifier
        
        let components = DateComponents(second: 3)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        try await current.add(request)
    }
    
}

extension LocalNotifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.list, .sound]
    }

}
