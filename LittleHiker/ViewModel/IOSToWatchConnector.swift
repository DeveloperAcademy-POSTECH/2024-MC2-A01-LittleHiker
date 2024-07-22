//
//  IOSWatchConnector.swift
//  LittleHiker
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity

final class IOSToWatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    @Published var id: String = ""
    @Published var body: String = ""
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Activation error: \(error.localizedDescription)")
        } else {
            print("Activation comleted with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //      self.message.append("Apple Watch 통신 중단")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //      self.message.append("세션이 이전 세션의 모든 데이터를 전달했으며 Apple Watch와의 통신이 종료되었음")
    }
    
    //watch 에서 message 받는거 (참고: 구현되어있는거 없음)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
        print("message received!")
        
        DispatchQueue.main.async {
            self.id = message["id"] as? String ?? ""
            if (message["data"] != nil) {
                self.body = message["data"] as? String ?? ""
            } else if (message["logs"] != nil) {
                self.body = message["logs"] as? String ?? ""
            }
            
            //TODO: replyHandler
//            replyHandler(message)
        }
        
    }
    
    //MARK: 통신 3. watch에서 가지고 온 UUID를 IOS swiftData에 조회
    ///watch와 iphone 데이터 비교. return : [String: String]
    func compareDataBetweenDevices(_ ids: String) -> [String: String]{
        var requestIds = [
            "getIDs" : "",  //데이터 get 대상 ID
            "cleanIDs" : "" //삭제 대상 ID
        ]
        
        //TODO: swiftData 조회
        return requestIds
    }
    
    
    /**
     Apple Watch에 데이터 전송
     - Parameters:
     - method: get(ID 요청), fetchAndClean(삭제 및 데이터 전송요청)
     - contents: 전송할 데이터 본문, Dictionary 형태
     */
    func sendDataToWatch(_ method: Method, _ contents: [String: String] = [:]) {
        if session.isReachable {
            let data: [String : Any] = [
                "method" : method,
                "contents" : contents
            ]
            
            session.sendMessage(data, replyHandler: { [self] response in
                if let data = response["response"] as? String {
                    print("Received data: \(data)")
                    processResponse(method, data)
                }
            }, errorHandler: { error in
                print(error.localizedDescription)
            })
        } else {
            print("session is not reachable")
        }
    }
    
    //WC response 처리
    func processResponse(_ method: Method, _ response: String) {
        switch method {
            case .get:
                let ids = compareDataBetweenDevices(response)
                //MARK: 통신 4. 삭제 및 데이터 전송요청
                sendDataToWatch(Method.fetchAndClean, ids)
                break;
            case .fetchAndClean:
                break;
        }
        
        
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Reachability changed to: \(session.isReachable)")
    }

    
}
