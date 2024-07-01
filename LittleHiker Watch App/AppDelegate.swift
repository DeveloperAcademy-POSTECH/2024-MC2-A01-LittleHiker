//
//  AppDelegate.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/1/24.
//
import Foundation
import UIKit
import UserNotifications
import WatchKit

class AppDelegate: NSObject, WKApplicationDelegate {
    private var notificationIdentifiers = Set<String>()
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    //TODO: willpresent가 왜 3번 호출되는지 확인해보기
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification will present method called")
        completionHandler([.list, .banner])
        if !notificationIdentifiers.contains(notification.request.identifier) {
            notificationIdentifiers.insert(notification.request.identifier)
        } else {
            WKInterfaceDevice.current().play(.notification)
            print("Haptic feedback triggered at \(Date()).")
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler:
                                @escaping () -> Void) {
        switch response.actionIdentifier {
        case "30분_끄기":
            // 30분동안 다람상식 끄기
            HikingViewModel.shared.impulseManager.localNotification.turnOffTipsFor30Minutes()
            break
            
        case "계속_끄기":
            // 계속 다람상식 끄기
            HikingViewModel.shared.impulseManager.localNotification.turnOffTips()
            break
        default:
            break
            
        }
        
    }
}
