//
//  ViewModelWatch.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity

final class ViewModelWatch: NSObject, WCSessionDelegate, ObservableObject {
    @Published var count: Int = 0
    var session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.count = message["count"] as? Int ?? 0
        }
    }
}
