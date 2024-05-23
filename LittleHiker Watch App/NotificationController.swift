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
    
    //Notification이 왔을 때 화면을 그리기
    var title: String?
    var imageName: String?
    var message: String?
    
    override var body: NotificationView {
        return NotificationView(
            title: title,
            imageName: imageName,
            message: message)
    }
    
    override func didReceive(_ notification: UNNotification) {
        let notificationData =
        notification.request.content.userInfo as? [String: Any]
        
        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        title = alert?["title"] as? String
        message = alert?["message"] as? String
        imageName = alert?["imageName"] as? String
        //       guard let index = notificationData?["landmarkIndex"] as? Int else { return }
        //       landmark = modelData.landmarks[index]
    }
    
}

