//
//  NotificationView.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/22/24.
//

import SwiftUI

struct NotificationView: View {
    var title: String?
    var imageName: String?
    var message: String?
    
    var body: some View {
        VStack{
            Image(imageName ?? "unknown imageName")
                .resizable()
                .scaledToFit()
            Text(title ?? "unknown title")
                .font(.headline)
            Text(message ?? "unknown message")
                .font(.caption)
        }
    }
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
