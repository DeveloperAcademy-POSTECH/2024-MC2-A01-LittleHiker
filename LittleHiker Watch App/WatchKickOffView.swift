//
//  KickOffView.swift
//  LittleHiker Watch App
//
//  Created by 박서현 on 5/13/24.
//

import SwiftUI

struct WatchKickOffView: View {
    @State var progress: Double = 0
    var body: some View {
        //시작화면
        VStack {
            Circle()
                .frame(width: 96, height: 96)
                .foregroundColor(.green)
                .overlay {
                    Text("시작")
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                }
                .shadow(color: .green.opacity(0.5), radius: 12)
            Text("리틀하이커랑 등산하기")
                .font(.system(size: 12))
                .fontWeight(.medium)
                .padding(.top, 12)
        }
        .padding()
        
        //준비하기 화면
        //        VStack {
        //            Circle()
        //                .trim(from: 0, to: progress)
        //                .stroke(Color.green, 
        //                        style: StrokeStyle(
        //                            lineWidth: 8,
        //                            lineCap: .round))
        //                .rotationEffect(.degrees(90))
        //                .animation(.easeOut(duration: 1), value: progress)
        //                .frame(width: 96, height: 96)
        //                .overlay {
        //                    Text("준비")
        //                        .font(.system(size: 24))
        //                        .fontWeight(.semibold)
        //                }
        //                .onReceive(Timer.publish(every:1, on: .main, in: .default).autoconnect()) { _ in
        //                    self.decreaseProgress()
        //                }
        //            
        //        }
        
        
        
        //3,2,1 화면
        //        CircularProgressView()
        //            .frame(width: 96, height: 96)
        
    }
    
    //준비화면의 progress를 0부터 1까지 채웁니다.
    //    func decreaseProgress() {
    //        if progress == 0 {
    //            progress += 1
    //        } else if progress == 1 {
    //            
    //        }
    //    }
}
//progress와 count가 포함된 구조체
//struct CircularProgressView: View {
//    @State var progress: Double = 1
//    @State var count: Int = 3
//    
//    var body: some View {
//        ZStack {
//배경에 깔려있는 빈 프로그레스
//            Circle()
//                .stroke(Color.green.opacity(0.5), lineWidth: 8)
//채워지는 프로그레스
//            Circle()
//                .trim(from: 0, to: progress)
//                .stroke(Color.green,
//                        style: StrokeStyle(
//                            lineWidth: 8,
//                            lineCap: .round))
//                .rotationEffect(.degrees(-90))
//                .animation(.easeOut, value: progress)
//                .onReceive(Timer.publish(every:1, on: .main, in: .default).autoconnect()) { _ in
//                    self.decreaseProgress()
//                }
//                .overlay {
//                    Text("\(count)")
//                        .font(.system(size: 40))
//                        .fontWeight(.medium)
//                }
//        }
//    }
//    
//1초가 지날 때마다 -.33값이 되는 progress입니다.
//    func decreaseProgress() {
//        if progress > 0.1 {
//            if progress != 1 {
//                count -= 1
//            }
//            progress -= 0.33
//        } else {
//            progress -= 0.1
//            //            NavigationLink(destination: WatchMainView()
//        }
//    }
//}

#Preview {
    WatchKickOffView()
}
