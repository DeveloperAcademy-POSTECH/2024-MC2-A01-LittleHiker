//
//  NotificationController.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/22/24.
//

import WatchKit
import SwiftUI
import UserNotifications


class NotificationController: WKUserNotificationHostingController<NotificationView> {
    var title: String?
    var message: String = ""
    
    let landmarkIndexKey = "landmarkIndex"
    
    override var body: NotificationView {
           return NotificationView()
       }
    
    override func didReceive(_ notification: UNNotification) {
        message = "Leeo"
       
//       guard let index = notificationData?["landmarkIndex"] as? Int else { return }
//       landmark = modelData.landmarks[index]
     }

}

