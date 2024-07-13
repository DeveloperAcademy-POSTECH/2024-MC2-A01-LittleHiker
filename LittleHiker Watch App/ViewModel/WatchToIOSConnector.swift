//
//  WatchToIOSConnector.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity

final class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    @Published var method: String = ""
    @Published var contents: [String: Any] = [:]
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
    private func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String: String]) -> Void) {
        var response = ["data": ""]
            
        DispatchQueue.main.async {
            self.method = (message["method"] as? String ?? "")
            
            switch self.method {
                //UUID 전송요청
                case "get":
                    response = self.getAllIds()
                    break;
                //TODO: 있는 UUID 지우고, 없는 UUID 데이터 가져오고
                case "fetchAndClean":
                    break;
                default:
                    break;
            }
            
            //TODO: 다른 Response 값 추가되면 if문 변경 필요(현재는 get만 구현)
            if let request = message["method"] as? String, request == "get" {
                // 응답 데이터 생성
                replyHandler(response)
            }
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
    
    //Watch SwiftData에 저장되어있는 전체 ID 가져오기
    func getAllIds() -> [String: String] {
        
        var ids = ["data" : ""];
        //TODO: UUID SwiftData 쿼리로 가져오기
        return ids
    }
    
    func sendDataToIOS(_ impulseRateLogs: [Double], _ timeStampLogs: [String]) {
        
        /* 전송데이터 형식
         1. CustomComplementaryHikingData
         2. LogsWithTimeStamps
         */
        
        
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
