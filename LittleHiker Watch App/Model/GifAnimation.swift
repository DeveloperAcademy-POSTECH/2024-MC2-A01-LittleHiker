//
//  GifAnimation.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/5/24.
//

import Foundation

enum GifAnimation: String {
    case run = "run"
    case eat = "eat"
    case peak = "peak"

    var frameCount: Int {
        switch self {
        case .run:
            return 4
        case .eat:
            return 5
        case .peak:
            return 4
        }
    }
    
    func frameImageName(index: Int) -> String {
        "\(self.rawValue)\(index + 1)"
    }
}
