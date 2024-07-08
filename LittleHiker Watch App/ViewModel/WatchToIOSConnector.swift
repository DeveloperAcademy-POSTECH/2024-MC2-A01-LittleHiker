//
//  WatchToIOSConnector.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity

//TODO: - IPhone 작업시 재사용

final class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    //
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    // 다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            // 받은 메세지에서 원하는 Key값(여기서는 "message")으로 메세지 String을 가져온다.
            // messageText는 Published 프로퍼티이기 때문에 DispatchQueue.main.async로 실행해줘야함
            
            
        }
    }
    
    //MARK: 수집한 배열데이터를 iOS에 보낼 String으로 변환
    func convertDataLogsToMessage(_ impulseRateLogs: [Double], _ timeStampLogs: [String]) -> [String: String] {
        
        var result: [String: String] = [:]
        
        for (i, log) in impulseRateLogs.enumerated() {
            result[timeStampLogs[i]] = String(impulseRateLogs[i])
        }
        
        return result
    }
    
    func sendDataToIOS(_ impulseRateLogs: [Double], _ timeStampLogs: [String]) {
        if session.isReachable {
            let data: [String: String] = self.convertDataLogsToMessage(impulseRateLogs, timeStampLogs)
            
            session.sendMessage(data, replyHandler: nil) { error in
                print(error.localizedDescription)
            }
            
        } else {
            print("session is not reachable")
        }
    }
    
}
