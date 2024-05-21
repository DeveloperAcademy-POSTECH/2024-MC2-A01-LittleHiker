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
                        
                        
                        // TODO: - 일단 여기다가 그냥 붙임
                        VStack {
                            Button(action: {
                                // Action to perform when button is tapped
                                //1. 버튼을 누르면 타이머를 멈춘다
                                //2. 기록이 SummaryView로 넘어감
                                //3. iOS로 데이터 동기화(배열 보내기)
                            }) {
                                RoundedRectangle(cornerRadius: 28)
                                    .frame(width: 68, height: 44)
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
//                        StopButton(height: 44)
                        //TODO: - 여기까지 수정 가라로 함
                        
                        //일시정지버튼
                        //                        PauseButton(height: 44)
                        //재개버튼
                        RestartButton(height: 44)
                    }
                    HStack {
                        //정상버튼
                        PeakButton(height: 44)
                        //하산버튼
                        DescendButton(height: 44)
                    }
                    
                }
                .padding()
            } else if viewModel.status == .peak {
                VStack {
                    HStack {
                        //종료버튼
                        StopButton(height: 56)
                        //하산버튼
                        DescendButton(height: 56)
                    }
                    Spacer()
                }
                .padding()
            } else if viewModel.status == .descending {
                VStack {
                    HStack {
                        //종료버튼
                        StopButton(height: 56)
                        
                        //일시정지버튼
                        PauseButton(height: 56)
                        //재개버튼
                        //                      RestartButton(height: 56)
                    }
                }
                .padding()
            }
            
        }
    }
}


//종료버튼
struct StopButton: View {
    var height: CGFloat
    
    var body: some View {
        VStack {
            Button(action: {
                // Action to perform when button is tapped
                //1. 버튼을 누르면 타이머를 멈춘다
                //2. 기록이 SummaryView로 넘어감
                //3. iOS로 데이터 동기화(배열 보내기)
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
    
    var body: some View {
        
        Button(action: {
            // Action to perform when button is tapped
            print("Button tapped!")
        }) {
            VStack {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: height)
                    .foregroundColor(.yellow)
                    .opacity(0.25)
                    .overlay {
                        Image(systemName: "arrow.circlepath")
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
    
    var body: some View {
        VStack {
            
            Button(action: {
                // Action to perform when button is tapped
                print("Button tapped!")
            }) {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: 44) // Adjust height as needed
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
    
    var body: some View {
        VStack {
            Button(action: {
                // Action to perform when button is tapped
                print("Button tapped!")
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
    
    var body: some View {
        VStack {
            Button(action: {
                // Action to perform when button is tapped
                print("Button tapped!")
            }) {
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 68, height: height)
                    .foregroundColor(.white)
                    .opacity(0.12)
                    .overlay {
                        Image(systemName: "arrow.down.right")
                            .foregroundStyle(Color.white)
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
    WatchButtonView(viewModel: HikingViewModel())
}
