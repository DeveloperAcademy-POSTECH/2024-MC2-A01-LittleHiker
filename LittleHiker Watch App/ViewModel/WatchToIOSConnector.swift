//
//  WatchToIOSConnector.swift
//  LittleHiker Watch App
//
//  Created by 백록담 on 5/21/24.
//

import Foundation
import WatchConnectivity
import WatchKit

final class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    @Published var method: String = ""
    @Published var contents: [String: Any] = [:]
    private var timeManager = TimeManager()
    
    
    private var fileTransferObservers = FileTransferObservers()
    
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = WCSession.default
        super.init()
        self.session.delegate = self
        session.activate()
    }

    
//    override func awake(withContext context: Any?) {
//            super.awake(withContext: context)
//            
//            if WCSession.isSupported() {
//                WCSession.default.delegate = self
//                WCSession.default.activate()
//            }
//        }
    
    
    //
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
                    print("WCSession activation failed with error: \(error.localizedDescription)")
                } else {
                    print("WCSession activated with state: \(activationState.rawValue)")
                }
    }
    
    /// 다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        var response = ["data": ""]
//            
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
////                replyHandler(response)
//            }
//        }
//    }
    
    //TODO: FileTransfer용 iPhone으로부터 메시지를 수신하는 메서드
       func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
           if let fileTransferID = message["fileTransferID"] as? String {
               print("File transfer completed: \(fileTransferID)")
               // 다음 파일 전송 트리거
//               triggerNextFileTransfer()
           }
       }
    
    
    ///WatchConnectivity 파일 전송 종료시 실행 ?
    // Did finish a file transfer.
    //
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("파일전송 종료")
        fileTransferObservers.unobserve(fileTransfer)
    }
    
    //MARK: 수집한 배열데이터를 iOS에 보낼 String으로 변환
    func convertDataLogsToMessage(_ impulseRateLogs: [Double], _ timeStampLogs: [String]) -> [String: String] {
        
        var result: [String: String] = [:]
        
        for (i, log) in impulseRateLogs.enumerated() {
            result[timeStampLogs[i]] = String(log)
        }
        
        return result
    }
    
    /// Watch SwiftData에 저장되어있는 전체 ID 가져오기
    @MainActor
    func getAllIds() -> [String: String] {
        
        let dataSource: DataSource = DataSource.shared
        
        var result = ["data" : ""];
        let data = dataSource.fetchCustomComplementaryHikingData()
        let ids = data.map { $0.id }.joined(separator: ",")
        
        result["data"] = ids
        print("IDs:"+ids)
        
        return result
    }
    
    ///iOS로 데이터 전송하는 공통함수
    @MainActor
    func sendDataToIOS(_ data: [String: String]) {
        print(data)
        if session.isReachable {
            if session.activationState == .activated {
                print("세션연결되어있다고오오오오오오")
                session.sendMessage(data, replyHandler: nil) { error in
                    print("sendMessage error")
                    print(error.localizedDescription)
                }
            } else {
                print("session is not activated")
            }
            
            
        } else {
            print("session is not reachable")
        }
    }
    
    //파일전송
    func transferFile(_ fileUrl: URL, _ metadata: [String:Any]?) {
        let fileTransfer = self.session.transferFile(fileUrl, metadata: metadata)

        fileTransferObservers.observe(fileTransfer) { _ in
            print(1111)
            self.logProgress(for: fileTransfer)
        }
        
        self.session.outstandingFileTransfers
            .filter({$0.progress.isFinished})
            .forEach { fileTransfer in
                print(222)
                fileTransfer.cancel()
            }
        
    }
    
    private func logProgress(for fileTransfer: WCSessionFileTransfer) {
        DispatchQueue.main.async {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            let timeString = dateFormatter.string(from: Date())
            let fileName = fileTransfer.file.fileURL.lastPathComponent
            
            let progress = fileTransfer.progress.localizedDescription ?? "No progress"
            print("- \(fileName): \(progress) at \(timeString)")
        }
    }
}
