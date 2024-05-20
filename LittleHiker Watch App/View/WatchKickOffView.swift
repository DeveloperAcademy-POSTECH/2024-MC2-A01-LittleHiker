//
//  KickOffView.swift
//  LittleHiker Watch App
//
//  Created by 박서현 on 5/13/24.
//

import SwiftUI

enum MyHikingStatus {
    case kickoff
    case preparing
    case countdown
}

struct WatchKickOffView: View {
    @ObservedObject var viewModel: HikingViewModel
    @State var status: MyHikingStatus = .kickoff
    
    var body: some View {
        VStack {
            switch status {
            case .kickoff:
                KickOffView(viewModel: viewModel, status: $status)
            case .preparing:
                PreparingView(viewModel: viewModel, status: $status)
            case .countdown:
                CountdownView(viewModel: viewModel)
            }
        }
    }
}

//시작 버튼 화면
struct KickOffView: View {
    @ObservedObject var viewModel: HikingViewModel
    @Binding var status: MyHikingStatus

    var body: some View {
        VStack {
            Button {
                status = .preparing
            } label: {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.main)
                    .overlay {
                        Text("시작")
                            .font(.system(size: 32))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }
                    .shadow(color: .main.opacity(0.3), radius: 12)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
        
        Text("리틀하이커랑 등산하기")
            .font(.system(size: 14))
            .fontWeight(.medium)
            .padding(.top, 16)
    }
}

struct PreparingView: View {
    @ObservedObject var viewModel: HikingViewModel
    @State var progress: Double = 0
    @Binding var status: MyHikingStatus
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.main,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round))
                .rotationEffect(.degrees(90))
                .animation(.easeOut(duration: 1), value: progress)
                .frame(width: 100, height: 100)
                .overlay {
                    Text("준비")
                        .font(.system(size: 32))
                        .fontWeight(.semibold)
                }
                //1초마다 타이머 이벤트를 수신하여 increase를 호출합니다.
                .onReceive(Timer.publish(every:1, on: .main, in: .default).autoconnect()) { _ in
                    self.increaseProgress()
                }

        }
    }
    //준비화면 progress를 0부터 1까지 채워주는 func
    private func increaseProgress() {
        if progress == 0 {
            progress += 1
        } else if progress == 1 {
            status = .countdown
        }
    }
}

// 카운트다운 화면
struct CountdownView: View {
    @ObservedObject var viewModel: HikingViewModel
    @State var count: Int = 3
    @State var progress: Double = 1
    
    var body: some View {
        ZStack {
            //뒤에 깔린 빈 프로그레스
            Circle()
                .stroke(Color.main.opacity(0.5), lineWidth: 8)
                .frame(width: 100, height: 100)
            //채워지는 프로그레스
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.main,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round))
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
                .onReceive(Timer.publish(every:1, on: .main, in: .default).autoconnect()) { _ in
                    self.decreaseProgress()
                }
                .overlay {
                    Text("\(count)")
                        .font(.system(size: 36))
                        .fontWeight(.medium)
                }
        }
    }
    //1초가 지날 때마다 -.33값이 되는 progress입니다.
    private func decreaseProgress() {
            if progress > 0.1 {
                if progress != 1 {
                    count -= 1
                }
                progress -= 0.33
            } else {
                progress -= 0.1
                viewModel.status = .hiking
            }
        }
}

//Preview
struct WatchKickOffView_Previews: PreviewProvider {
    static var previews: some View {
        WatchKickOffView(viewModel: HikingViewModel())
    }
}
