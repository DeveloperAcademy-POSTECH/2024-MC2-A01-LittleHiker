//
//  WatchButtonView.swift
//  LittleHiker Watch App
//
//  Created by Kyuhee hong on 5/15/24.
//

import SwiftUI

// [등산 중], [정상], [하산 중] 3 가지 상태에 따른 버튼 뷰 구현
struct WatchButtonView: View {
    var hikingStatus: String = "등산 중"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                //State or Binding 변수에 따라 등산중/ 정상/ 하산중 구현 예정
                //이 부분 아마 네비게이션으로 될듯?
                Text("\(hikingStatus)")
                    .foregroundStyle(Color.blue)
            }
            Spacer()
            
            if hikingStatus == "등산 중" {
                VStack {
                    HStack {
                        //종료버튼
                        StopButton(height: 44)
                        
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
            } else if hikingStatus == "정상" {
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
            } else if hikingStatus == "하산 중" {
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
                print("Button tapped!")
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
    WatchButtonView()
}
