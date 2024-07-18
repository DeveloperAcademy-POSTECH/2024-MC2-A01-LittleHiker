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
    let dataSource: DataSource = DataSource.shared
    
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
    
    /// 다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
    private func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String: String]) -> Void) {
        var response = ["data": ""]
        print("didReceived!!!!!")
            
//        DispatchQueue.main.async {
//            self.method = (message["method"] as? String ?? "")
//            
//            switch self.method {
//                //MARK: 통신 2. watch에서 메세지 받아서 UUID 조회요청처리
//                case "get":
//                    response = self.getAllIds()
//                    break;
//                //TODO: 있는 UUID 지우고, 없는 UUID 데이터 가져오고
//                case "fetchAndClean":
//                    break;
//                default:
//                    break;
//            }
//            
//            //TODO: 다른 Response 값 추가되면 if문 변경 필요(현재는 get만 구현)
//            if let request = message["method"] as? String, request == "get" {
//                // 응답 데이터 생성
//                replyHandler(response)
//            }
//        }
    }
    
    //MARK: 수집한 배열데이터를 iOS에 보낼 String으로 변환
    func convertDataLogsToMessage(_ impulseRateLogs: [Double], _ timeStampLogs: [String]) -> [String: String] {
        
        var result: [String: String] = [:]
        
        for (i, log) in impulseRateLogs.enumerated() {
            result[timeStampLogs[i]] = String(log)
        }
        
        return result
    }
    
    //Watch SwiftData에 저장되어있는 전체 ID 가져오기
    @MainActor //FIXME: 이거 꼭 MainActor 로 실행되어야 하는지 다른 방법은 없는지 알아보고싶습니다(이거 안쓰면 에러남) / 메인액터의 할 일은 메인 스레드에서 실행되게 하는 것이라고 함
    func getAllIds() -> [String: String] {
        
        var result = ["data" : ""];
        let data = dataSource.fetchCustomComplementaryHikingData()
        let ids = data.map { $0.id }.joined(separator: ",")
        
        result["data"] = ids
        print("IDs:"+ids)
        
        return result
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
    
    //TODO: 테스트 끝나면 지우기
    /// 테스트용 IOS WatchConnectivity
    func sendTestDataToIOS() {
        
        /* 전송데이터 형식
         1. CustomComplementaryHikingData
         2. LogsWithTimeStamps
         */
        if session.isReachable {
            let data: [String: String] = ["response":"result"]
            
            session.sendMessage(data, replyHandler: nil) { error in
                print(error.localizedDescription)
            }
            
        } else {
            print("session is not reachable")
        }
    }
    
}
