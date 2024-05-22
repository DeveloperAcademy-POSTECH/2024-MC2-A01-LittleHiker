//
//  NotificationView.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/22/24.
//

import SwiftUI

struct NotificationView: View {
  var title: String?
  var message: String?
  
  var body: some View {
    VStack {
      
      Text(title ?? "Unknown Landmark")
        .font(.headline)
      
      Divider()
      
      Text(message ?? "You are within 5 miles of one of your favorite landmarks.")
        .font(.caption)
    }
    .lineLimit(0)
  }
}


struct NotificationView_Previews: PreviewProvider {
  static var previews: some View {
    Group { // <-
      NotificationView()
      NotificationView(
        title: "Turtle Rock",
        message: "You are within 5 miles of Turtle Rock."
      )
    }
  }
}
