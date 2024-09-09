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
    @Published var resultArray: [String:Any] = [:]
    
    let viewModel = HikingViewModel()
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
    
    // 파일 수신 메서드
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let fileURL = file.fileURL
        
        // 파일을 원하는 위치로 이동 또는 처리
        let destinationURL = getDestinationURL(for: fileURL)
        do {
            try FileManager.default.moveItem(at: fileURL, to: destinationURL)
            
            // 파일 내용을 정리
            let data = try Data(contentsOf: destinationURL)
            
            // 데이터가공 후 저장
            viewModel.saveDataFromWatch(data)
            
            // 파일 전송 완료 메시지를 watchOS로 보냄
            //파일전송 실패 이슈가 있어서 확인용 message를 보내기 위함
            let message = ["fileTransferID": destinationURL.lastPathComponent]
            session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to send file to watch: \(error.localizedDescription)")
            })
        } catch {
            //iphone은 메세지 출력이 안되기 때문에 화면에 출력
            self.body.append(error.localizedDescription)
        }
        
        
        // outstandingFileTransfers 클린업 코드
        session.outstandingFileTransfers
            .filter({ $0.progress.isFinished })
            .forEach { fileTransfer in
                fileTransfer.cancel()
            }
    }
    
    func getDestinationURL(for fileURL: URL) -> URL {
        // 파일을 저장할 경로 반환
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsPath.appendingPathComponent(fileURL.lastPathComponent)
    }
    
    
    // 파일 전송 완료 후 호출되는 메서드
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if error == nil {
            // 파일 전송이 완료된 경우
            let message = ["fileTransferID": fileTransfer.file.fileURL.lastPathComponent]
            session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Failed to send message to watch: \(error.localizedDescription)")
            })
        } else {
            // 에러 처리
            print("File transfer failed: \(error!.localizedDescription)")
        }
        
        // 추가: outstandingFileTransfers 클린업 코드
        session.outstandingFileTransfers
            .filter({ $0.progress.isFinished })
            .forEach { fileTransfer in
                fileTransfer.cancel()
            }
    }
    
    //MARK: WCSessionFile에서 데이터를 읽어와 String 형식의 Dictionary로 변환하는 함수
    func parseWCSessionFile(file: WCSessionFile) -> [String: String]? {
        do {
            // 파일 경로에서 데이터를 읽어옴
            let fileData = try Data(contentsOf: file.fileURL)
            
            // 데이터를 문자열로 변환 (UTF-8 인코딩 사용)
            guard let jsonString = String(data: fileData, encoding: .utf8) else {
                print("Failed to convert data to String")
                return nil
            }
            
            // 문자열 데이터를 JSON 형식의 Dictionary로 변환
            if let jsonData = jsonString.data(using: .utf8) {
                let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]
                return dictionary
            } else {
                print("Failed to convert String to Data")
                return nil
            }
        } catch {
            print("Error reading file or parsing JSON: \(error.localizedDescription)")
            return nil
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
