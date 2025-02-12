//
//  SpeechManager.swift
//  LittleHiker
//
//  Created by sungkug_apple_developer_ac on 2/7/25.
//

import AVFoundation

class SpeechManager {
    let synthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.5

        synthesizer.speak(utterance)
    }
    
    func speakEmergencyAlert() {
        speak(text: "위험 상황이 감지되었습니다!")
    }
}
