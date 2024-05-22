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

    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.message.append(message["message"] as? String ?? "")
        }
    }

}
