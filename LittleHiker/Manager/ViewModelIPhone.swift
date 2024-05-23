//
//  ViewModelIPhone.swift
//  LittleHiker
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity

final class ViewModelIPhone: NSObject, WCSessionDelegate, ObservableObject {
    @Published var message: String = ""
    var session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
      self.message.append("Apple Watch 세션이 활성화 됨")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
      self.message.append("Apple Watch 통신 중단")
    }

    func sessionDidDeactivate(_ session: WCSession) {
      self.message.append("세션이 이전 세션의 모든 데이터를 전달했으며 Apple Watch와의 통신이 종료되었음")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.message = (message["message"] as? String ?? "")
        }
    }

}
