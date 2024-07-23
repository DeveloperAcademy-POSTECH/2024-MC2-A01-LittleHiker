//
//  HikingStatus.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/5/24.
//

import Foundation

enum HikingStatus{
    case ready
    case hiking
    //    case stop
    case hikingPause
    case descendingPause
    case peak
    case descending
    case complete
    
    // 상태별 네이게이션바에 보여줄 텍스트
    var getData : String {
        switch self{
        case .ready :
            return "준비"
        case .hiking :
            return "등산중"
        case .hikingPause :
            return "일시정지"
        case .descendingPause :
            return "일시정지"
        case .peak :
            return "정상"
        case .descending :
            return "하산중"
        case .complete :
            return "완료"
        }
    }
}
