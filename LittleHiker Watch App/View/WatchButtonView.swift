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
    @Binding var selection: String
    //    @State private var isShowingModal = false
    
    //    init() {
    //        UINavigationBar.appearance().largeTitleTextAtributes = [.foregroundColor: UIColor.blue]
    //    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(viewModel.status.getData)")
                    .foregroundStyle(Color.main)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .padding(.top, 30)
            Spacer()
            
            if viewModel.status == .hiking || viewModel.status == .hikingStop{
                VStack {
                    HStack {
                        //종료버튼
                        EndButton(height: 44, timeManager: timeManager, viewModel: viewModel, selection: $selection)
                            .padding(.trailing, 8)
                        
                        //일시정지,재개버튼
                        if pauseResumeToggle == true {
                            PauseButton(height: 44, timeManager: timeManager, toggle: $pauseResumeToggle, viewModel: viewModel)
                        } else {
                            RestartButton(height: 44, timeManager: timeManager, toggle: $pauseResumeToggle, viewModel: viewModel)
                        }
                    }
                    HStack {
                        //정상버튼
                        PeakButton(height: 44, timeManager: timeManager, viewModel: viewModel, selection: $selection)
                            .padding(.trailing, 8)
                        //하산버튼
                        DescendButton(height: 44, timeManager: timeManager, viewModel: viewModel, selection: $selection)
                    }
                    .padding(.top, 8)
                    
                }
                .padding()
            } else if viewModel.status == .peak {
                VStack {
                    HStack {
                        //종료버튼
                        EndButton(height: 56, timeManager: timeManager, viewModel: viewModel, selection: $selection)
                            .padding(.trailing, 8)
                        //하산버튼
                        DescendButton(height: 56, timeManager: timeManager, viewModel: viewModel, selection: $selection)
                    }
                }
                .padding()
            } else if viewModel.status == .descending || viewModel.status == .descendingStop{
                VStack {
                    HStack {
                        //종료버튼
                        EndButton(height: 56, timeManager: timeManager, viewModel: viewModel, selection: $selection)
                            .padding(.trailing, 8)
                        
                        //일시정지,재개버튼
                        if pauseResumeToggle == true {
                            PauseButton(height: 56, timeManager: timeManager, toggle: $pauseResumeToggle, viewModel: viewModel)
                        } else {
                            RestartButton(height: 56, timeManager: timeManager, toggle: $pauseResumeToggle, viewModel: viewModel)
                        }
                    }
                }.padding()
            }
            Spacer()
        }
        .padding(.horizontal, 9)
        //모달로 관리하면 기본으로 x가 있어서 메인앱에서 viewModel.status 로 관리해야 될 듯
        //            .fullScreenCover(isPresented: $viewModel.isShowingModal) {
        //                WatchSummaryView(viewModel: viewModel, timeManager: timeManager)
        //            }
        .fullScreenCover(isPresented: $viewModel.isShowingModal) {
            WatchSummaryView(viewModel: viewModel, timeManager: timeManager)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    //종료버튼
    struct EndButton: View {
        //    var viewModelWatch = ViewModelWatch()
        
        var height: CGFloat
        var timeManager: TimeManager
        @State var arrayText = ""
        //FIXME: - 테스트용으로 Array를 만들어보았습니다. 수정합시다.
        //    var heartRateArray = [100, 90, 80, 70]
        @ObservedObject var viewModel: HikingViewModel
        @Binding var selection: String
        
        var body: some View {
            VStack {
                Button(action: {
                    //1. 버튼을 누르면 타이머를 멈춘다
                    timeManager.pauseStopWatch()
                    
                    //전체산행시간에서 등산시간을 뺀 하산시간이 계산됨
                    timeManager.setDescendingDuration()
                    //2. 기록이 SummaryView로 넘어감
                    //2-1. 종료버튼을 누르면 SummaryView가 모달로 뜸
                    //3. iOS로 데이터 동기화(배열 보내기)=
                    //산행상태를 "완료"로 변경
                    
                    viewModel.endHiking()
                    viewModel.stop()
                    viewModel.status = .complete
                    //                viewModel.isShowingModal = true
                    
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
        @ObservedObject var viewModel: HikingViewModel
        
        var body: some View {
            Button(action: {
                toggle.toggle()
                print("PauseButton Tapped")
                //1. 타이머가 멈춘다.
                timeManager.pauseStopWatch()
                //2. 기록이 멈춘다.
                viewModel.pause()
                
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
        @ObservedObject var viewModel: HikingViewModel
        
        var body: some View {
            VStack {
                Button(action: {
                    print("RestartButton Tapped")
                    timeManager.runStopWatch()
                    toggle.toggle()
                    viewModel.restart()

                }) {
                    RoundedRectangle(cornerRadius: 28)
                        .frame(width: 68, height: height)
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
        @Binding var selection: String
        
        var body: some View {
            VStack {
                Button(action: {
                    print("PeakButton Tapped")
                    
                    timeManager.pauseStopWatch()
                    //전체산행시간에서 등산시간이 정해짐
                    timeManager.setAscendingDuration()
                    //뷰모델에서 산행상태를 정상으로 변경
                    viewModel.status = .peak
                    selection = "default"
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
        @Binding var selection: String
        
        var body: some View {
            VStack {
                Button(action: {
                    if ((timeManager.timer?.isValid) != nil) {
                        timeManager.timer?.invalidate()
                    }
                    timeManager.runStopWatch()
                    
                    //뷰모델에서 산행상태를 정상으로 변경
                    viewModel.status = .descending
                    viewModel.isDescent = true
                    selection = "default"
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
}

#Preview {
    WatchButtonView(viewModel: HikingViewModel(), timeManager: TimeManager(), selection: .constant("default"))
}
