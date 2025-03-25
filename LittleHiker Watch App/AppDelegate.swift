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
    var timeManager: TimeManager?
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
            LocalNotifications.shared.turnOffTipsFor30Minutes()
            break
            
        case "계속_끄기":
            // 계속 다람상식 끄기
            LocalNotifications.shared.turnOffTips()
            break
            
        case "하산모드_진입": {
            let viewModel = HikingViewModel.shared
            if let timeManager = timeManager {
                if ((timeManager.timer?.isValid) != nil) {
                    timeManager.timer?.invalidate()
                }
                let viewModel = HikingViewModel.shared
                // peak 버튼을 누르지 않고 바로 하산 버튼을 눌렀을 경우에 처리
                if viewModel.status == .hiking || viewModel.status == .hikingPause {
                    timeManager.setAscendingDuration()
                }
                
                timeManager.runStopWatch()
                //하이킹 워크아웃 재시작
                viewModel.healthKitManager.resumeHikingWorkout()
                
                //뷰모델에서 산행상태를 정상으로 변경
                viewModel.status = .descending
                viewModel.isDescent = true
            }
        }()
            
        default:
            break
        }
    }
}
