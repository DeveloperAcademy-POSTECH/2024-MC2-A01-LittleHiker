//
//  ConnectManager.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/21/24.
//

//  ViewModelWatch.swift
import Foundation
import WatchConnectivity

class ConnectManager: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var messageText = "" // iOS 앱에서 수신한 메세지를 화면에 보여주기 위한 문자열
    @Published var number = ""
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // 다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            // 받은 메세지에서 원하는 Key값(여기서는 "message")으로 메세지 String을 가져온다.
            // messageText는 Published 프로퍼티이기 때문에 DispatchQueue.main.async로 실행해줘야함
            self.messageText = message["message"] as? String ?? "Unknown"
        }
    }
    
    // 다른 기기의 세션으로부터 transferUserInfo() 메서드로 데이터를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            self.number = userInfo["number"] as? String ?? "0"
        }
    }
}
