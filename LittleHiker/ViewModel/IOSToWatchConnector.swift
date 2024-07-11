//
//  IOSWatchConnector.swift
//  LittleHiker
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity

//TODO: - IPhone 작업시 재사용
final class IOSToWatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    @Published var message: String = "2.9"
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

    //받는거
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.message = (message["message"] as? String ?? "")
            //TODO: 데이터 가공 + HealthStore데이터 가공해서 SwiftData로 저장해야함
            //[timeStamp: String] -> [timestamp: Double]
            //Dictionary라 정렬 안 되어있어서 sort해야함
            
        }
    }

}
