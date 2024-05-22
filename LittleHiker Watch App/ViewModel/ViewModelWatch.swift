//
//  ViewModelWatch.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity

final class ViewModelWatch: NSObject, WCSessionDelegate, ObservableObject {
    @Published var impulseRate: String = ""
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // 다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            // 받은 메세지에서 원하는 Key값(여기서는 "message")으로 메세지 String을 가져온다.
            // messageText는 Published 프로퍼티이기 때문에 DispatchQueue.main.async로 실행해줘야함
            self.impulseRate = message["message"] as? String ?? "2.7"
        }
    }
    
    func handleImpulseRate(impulseRate: String) {
        let impulseManager = ImpulseManager()
        impulseManager.diagonalVelocityCriterion = impulseRate
        // Now use viewModelWatch.impulseRate in your view or other logic
    }
    
    
    
}
