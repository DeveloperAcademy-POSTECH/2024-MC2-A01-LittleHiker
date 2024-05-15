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
                //?? 이거 위치 고정이 안되는듯 나중에 기본 컴포넌트로 보여주는 방법이 따로 있을까??
                Text("\(hikingStatus)")
                    .foregroundStyle(Color.blue)
            }
            Spacer()
            
            if hikingStatus == "등산 중" {
                VStack {
                    HStack {
                        //종료버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 44)
                                .foregroundColor(.red)
                                .opacity(0.25)
                                .overlay {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(Color.red)
                                }
                            Text("종료")
                                .font(.system(size: 12))
                        }
                        
                        //일시정지버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 44)
                                .foregroundColor(.yellow)
                                .opacity(0.25)
                                .overlay {
                                    Image(systemName: "pause.fill")
                                        .foregroundStyle(Color.yellow)
                                }
                            Text("일시정지")
                                .font(.system(size: 12))
                        }
                    }
                    
                    HStack {
                        //정상버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 44)
                                .foregroundColor(.green)
                                .opacity(0.25)
                                .overlay {
                                    Image(systemName: "mountain.2.fill")
                                        .foregroundStyle(Color.green)
                                }
                            Text("정상")
                                .font(.system(size: 12))
                        }
                        
                        //하산버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 44)
                                .foregroundColor(.white)
                                .opacity(0.12)
                                .overlay {
                                    Image(systemName: "arrow.down.right")
                                        .foregroundStyle(Color.white)
                                }
                            Text("하산")
                                .font(.system(size: 12))
                        }
                    }
                    
                }
                .padding()
            } else if hikingStatus == "정상" {
                VStack {
                    HStack {
                        //종료버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 56)
                                .foregroundColor(.red)
                                .opacity(0.25)
                                .overlay {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(Color.red)
                                }
                            Text("종료")
                                .font(.system(size: 12))
                        }
                        
                        //하산버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 56)
                                .foregroundColor(.white)
                                .opacity(0.12)
                                .overlay {
                                    Image(systemName: "arrow.down.right")
                                        .foregroundStyle(Color.white)
                                }
                            Text("하산")
                                .font(.system(size: 12))
                        }
                    }
                    Spacer()
                }
                .padding()
            } else if hikingStatus == "하산 중" {
                VStack {
                    HStack {
                        //종료버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 56)
                                .foregroundColor(.red)
                                .opacity(0.25)
                                .overlay {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(Color.red)
                                }
                            Text("종료")
                                .font(.system(size: 12))
                        }
                        
                        //일시정지버튼
                        VStack {
                            RoundedRectangle(cornerRadius: 28)
                                .frame(width: 68, height: 56)
                                .foregroundColor(.yellow)
                                .opacity(0.25)
                                .overlay {
                                    Image(systemName: "pause.fill")
                                        .foregroundStyle(Color.yellow)
                                }
                            Text("일시정지")
                                .font(.system(size: 12))
                        }
                    }
                }
                .padding()
            }
            
        }
    }
}

#Preview {
    WatchButtonView()
}
