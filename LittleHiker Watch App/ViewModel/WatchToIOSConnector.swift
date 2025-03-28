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
    private var timeManager = TimeManager()
    private var fileTransferObservers = FileTransferObservers()
    
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = WCSession.default
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    /// 다른 기기의 세션에서 sendMessage() 메서드로 메세지를 받았을 때 호출되는 메서드
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
    
    //파일전송
    func transferFile(_ fileUrl: URL, _ metadata: [String: Any]?) {
        let fileTransfer = self.session.transferFile(fileUrl, metadata: metadata)
        
        fileTransferObservers.observe(fileTransfer) { _ in
            self.logProgress(for: fileTransfer)
        }
        
        self.session.outstandingFileTransfers
            .filter({$0.progress.isFinished})
            .forEach { fileTransfer in
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
            
            // 파일 크기 체크
            let fileSize: String
            do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileTransfer.file.fileURL.path)
                if let fileSizeInBytes = fileAttributes[.size] as? Int64 {
                    fileSize = ByteCountFormatter.string(fromByteCount: fileSizeInBytes, countStyle: .file)
                } else {
                    fileSize = "Unknown size"
                }
            } catch {
                fileSize = "Error retrieving size"
            }
            
            print("- \(fileName): \(progress) at \(timeString) [Size: \(fileSize)]")
        }
    }
}
