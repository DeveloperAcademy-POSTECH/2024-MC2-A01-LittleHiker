//
//  WatchButtonView.swift
//  LittleHiker Watch App
//
//  Created by Kyuhee hong on 5/15/24.
//

import SwiftUI

// [등산 중], [정상], [하산 중] 3 가지 상태에 따른 버튼 뷰 구현
struct WatchButtonView: View {
    @ObservedObject var viewModel: HikingViewModel
    
    //MARK: - norang 일시정지, 재개 버튼 토글
    @ObservedObject var timeManager: TimeManager
    @State var pauseResumeToggle: Bool = true
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(viewModel.status.getData)")
                    .foregroundStyle(Color.blue)
            }
            Spacer()
            
            if viewModel.status == .hiking {
                VStack {
                    HStack {
                        //종료버튼
                        StopButton(height: 44, timeManager: timeManager, viewModel: viewModel)
                        
                        //일시정지,재개버튼
                        if pauseResumeToggle == true {
                            PauseButton(height: 44, timeManager: timeManager, toggle: $pauseResumeToggle)
                        } else {
                            RestartButton(height: 44, timeManager: timeManager, toggle: $pauseResumeToggle)
                        }
                    }
                    HStack {
                        //정상버튼
                        PeakButton(height: 44, timeManager: timeManager, viewModel: viewModel)
                            .padding(.trailing, 8)
                        //하산버튼
                        DescendButton(height: 44, timeManager: timeManager, viewModel: viewModel)
                    }
                    .padding(.top, 8)
                    
                }
                .padding()
            } else if viewModel.status == .peak {
                VStack {
                    HStack {
                        //종료버튼
                        StopButton(height: 56, timeManager: timeManager, viewModel: viewModel)
                        //하산버튼
                        DescendButton(height: 56, timeManager: timeManager, viewModel: viewModel)
                    }
                    Spacer()
                }
                .padding()
            } else if viewModel.status == .descending {
                VStack {
                    HStack {
                        //종료버튼
                        StopButton(height: 56, timeManager: timeManager, viewModel: viewModel)
                        
                        //일시정지,재개버튼
                        if pauseResumeToggle == true {
                            PauseButton(height: 56, timeManager: timeManager, toggle: $pauseResumeToggle)
                        } else {
                            RestartButton(height: 56, timeManager: timeManager, toggle: $pauseResumeToggle)
                        }
                        
                    }
                }
                .padding()
            }
            
        }
    }
}

//종료버튼
struct StopButton: View {
//    var viewModelWatch = ViewModelWatch()
    
    var height: CGFloat
    var timeManager: TimeManager
    @State var arrayText = ""
    //FIXME: - 테스트용으로 Array를 만들어보았습니다. 수정합시다.
//    var heartRateArray = [100, 90, 80, 70]
    @ObservedObject var viewModel: HikingViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                //1. 버튼을 누르면 타이머를 멈춘다
                timeManager.pauseStopWatch()
                // TODO: - 2. 기록이 SummaryView로 넘어감
//                let joinedString = zip(viewModel.coreLocationManager.impulseLogs , viewModel.coreLocationManager.speedLogs)
//                    .map { "impulse : \($0), H_speed : \($1)" }
//                    .joined(separator: "\n")
                
                //3. iOS로 데이터 동기화(배열 보내기)=
//                self.viewModelWatch.session.sendMessage(["message" : joinedString], replyHandler: nil) { error in
                    /**
                     다음의 상황에서 오류가 발생할 수 있음
                     -> property-list 데이터 타입이 아닐 때
                     -> watchOS가 reachable 상태가 아닌데 전송할 때
                     */
//                    print(error.localizedDescription)
//                    
//                }

                //전체산행시간에서 등산시간을 뺀 하산시간이 계산됨
                timeManager.setDescendingDuration()
                //2. 기록이 SummaryView로 넘어감
                //3. iOS로 데이터 동기화(배열 보내기)=
                //산행상태를 "완료"로 변경
                viewModel.endHiking()
                viewModel.status = .complete
                print("StopButton Tapped")
            }) {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: height)
                    .foregroundColor(.red)
                    .opacity(0.25)
                    .overlay {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.red)
                            .fontWeight(.bold)
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text("종료")
                .font(.system(size: 12))
        }
    }
}

//일시정지버튼
struct PauseButton: View {
    var height: CGFloat
    var timeManager: TimeManager
    @Binding var toggle: Bool
    
    var body: some View {
        Button(action: {
            print("PauseButton Tapped")
            //1. 타이머가 멈춘다.
            timeManager.pauseStopWatch()
            //2. 기록이 멈춘다.
        }) {
            VStack {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: height)
                    .foregroundColor(.yellow)
                    .opacity(0.25)
                    .overlay {
                        Image(systemName: "pause.fill")
                            .foregroundStyle(Color.yellow)
                            .fontWeight(.bold)
                    }
                Text("일시정지")
                    .font(.system(size: 12))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//재개버튼
struct RestartButton: View {
    var height: CGFloat
    var timeManager: TimeManager
    @Binding var toggle: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                print("RestartButton Tapped")
                timeManager.runStopWatch()
                toggle.toggle()
            }) {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: 44)
                    .foregroundColor(.yellow)
                    .opacity(0.25)
                    .overlay {
                        Image(systemName: "arrow.circlepath")
                            .foregroundStyle(Color.yellow)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text("재개")
                .font(.system(size: 12))
        }
    }
}

//정상버튼
struct PeakButton: View {
    var height: CGFloat
    var timeManager: TimeManager
    @ObservedObject var viewModel: HikingViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                print("PeakButton Tapped")

                timeManager.pauseStopWatch()
                //전체산행시간에서 등산시간이 정해짐
                timeManager.setAscendingDuration()
                //뷰모델에서 산행상태를 정상으로 변경
                viewModel.status = .peak
            }) {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: height)
                    .foregroundColor(.green)
                    .opacity(0.25)
                    .overlay {
                        Image(systemName: "mountain.2.fill")
                            .foregroundStyle(Color.green)
                            .fontWeight(.bold)
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text("정상")
                .font(.system(size: 12))
        }
    }
}

//하산버튼
struct DescendButton: View {
    var height: CGFloat
    var timeManager: TimeManager
    @ObservedObject var viewModel: HikingViewModel

    var body: some View {
        VStack {
            Button(action: {
                timeManager.runStopWatch()
                
                //뷰모델에서 산행상태를 정상으로 변경
                viewModel.status = .descending
                viewModel.isDescent = true
            }) {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: height)
                    .foregroundColor(.green)
                    .opacity(0.25)
                    .overlay {
                        Image(systemName: "arrow.down.right")
                            .foregroundStyle(Color.green)
                            .fontWeight(.bold)
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text("하산")
                .font(.system(size: 12))
        }
    }
}

#Preview {
    WatchButtonView(viewModel: HikingViewModel(), timeManager: TimeManager())
}
