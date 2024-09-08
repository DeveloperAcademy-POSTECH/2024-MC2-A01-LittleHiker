//
//  LabelCoefficients.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/5/24.
//

import Foundation

enum LabelCoefficients{
    case green
    case yellow
    case red
    
    var coefficients : Double{
        switch self{
        case .green:
            return 1.3
        case .yellow:
            return 1.7
        case .red:
            return 2.1
        }
    }
}
