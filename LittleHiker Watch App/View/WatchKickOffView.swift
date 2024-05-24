//
//  KickOffView.swift
//  LittleHiker Watch App
//
//  Created by 박서현 on 5/13/24.
//

import SwiftUI
import UserNotifications
import UIKit

enum MyHikingStatus {
    case kickoff
    case preparing
    case countdown
}


class AppDelegate: NSObject, WKApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        
//        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
//        UNUserNotificationCenter.current().delegate = self
//        
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: { _, _ in }
//        )
//        return true
//    }
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}

struct WatchKickOffView: View {
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var timeManager: TimeManager
    
    @State var status: MyHikingStatus = .kickoff
    
    var body: some View {
        VStack {
            switch status {
            case .kickoff:
                KickOffView(viewModel: viewModel, status: $status)
            case .preparing:
                PreparingView(viewModel: viewModel, status: $status)
            case .countdown:
                CountdownView(viewModel: viewModel, timeManager: timeManager)
            }
        }
        .onAppear {
//            var instance = LocalNotifications()
//            instance.schedule()
//            UNUserNotificationCenter.current()
//                .requestAuthorization(options: [.alert, .sound]){ granted, error in
//                    if granted {
//                        print("로컬 알림 권한x이 허용되었습니다")
//                    } else {
//                        print("로컬 알림 권한이 허용되지 않았습니다")
//                    }
//                }
            
            
            let current = UNUserNotificationCenter.current()
//            current.removeAllPendingNotificationRequests()
            //        let settings = await current.notificationSettings()
            //
            //        //notification setting이 enabled 되어 있을 때만 schedule을 할 수 있음. 아니면 schedule 자체가 의미 없음
            //        guard settings.alertSetting == .enabled else { return }
            current.requestAuthorization(options: [.alert, .sound]) { granted, error in

                if granted {
                    print("허용되었습니다")
                    let content = UNMutableNotificationContent()
                    content.title = "되어랏~"
                    content.subtitle = "다람이 missing"
                    content.body = "다람이가 못따라오고 있어요"
                    content.categoryIdentifier = "custom"
//
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                        content: content,
                                                        trigger: trigger)
//                    current.add(request)
                    
                    // Schedule the request with the system.
//                    let notificationCenter = UNUserNotificationCenter.current()
//                    do {
//                        Task {
////                            current.removeAllPendingNotificationRequests()
//                            try await current.add(request)
//                        }
//                        
//                    } catch {
//                        // Handle errors that may occur during add.
//                    }
//                    current.removeAllPendingNotificationRequests()
                    current.add(request)
                } else {
                    print("로컬 알림 권한이 허용되지 않았습니다")
                }
                
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
            .padding(.top, 6)
    }
}

struct PreparingView: View {
    @ObservedObject var viewModel: HikingViewModel
    @State var progress: Double = 0
    @Binding var status: MyHikingStatus
    @State private var timer: Timer? = nil

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
//                .onReceive(Timer.publish(every:1, on: .main, in: .default).autoconnect()) { _ in
//                    self.increaseProgress()
//                }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
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
    
    private func startTimer() {
        print("준비 타이머 시작 할거야")

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.increaseProgress()
        }
    }
    
    // 타이머 중지
    private func stopTimer() {
        print("준비 타이머 끌거야")

        timer?.invalidate()
        timer = nil
    }
}

// 카운트다운 화면
struct CountdownView: View {
    @ObservedObject var viewModel: HikingViewModel
    @ObservedObject var timeManager: TimeManager
    
    @State var count: Int = 3
    @State var progress: Double = 1
    @State private var timer: Timer? = nil
    
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
//                .onReceive(Timer.publish(every:1, on: .main, in: .default).autoconnect()) { _ in
//                    self.decreaseProgress()
//                }
                .overlay {
                    Text("\(count)")
                        .font(.system(size: 36))
                        .fontWeight(.medium)
                }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
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
            
            //TODO: - 여기서 기존에 쓰던 데이터 값이 있다면 초기화해줌
            if !viewModel.impulseManager.impulseLogs.isEmpty {
                timeManager.elapsedTime = 0
                viewModel.healthKitManager = HealthKitManager()
                viewModel.coreLocationManager = CoreLocationManager()
                viewModel.impulseManager = ImpulseManager(localNotification: LocalNotifications())
                viewModel.summaryModel = SummaryModel()
            }
            
            //3,2,1 끝나고 뷰가 바뀌기 직전에 스탑워치 시작!
            timeManager.runStopWatch()
            //기록 날짜 "yyyy년 mm월 dd일" 찍기
            timeManager.setToday()
            //시작 시간 찍기
            timeManager.setStartTime(Date())
            
            //뷰 바꾸기
            viewModel.status = .hiking
            viewModel.isDescent = false
            
            //active 임시
            viewModel.healthKitManager.startHikingWorkout()
        }
    }
    
    private func startTimer() {
        print("카운드 다운 타이머 시작 할거야")

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.decreaseProgress()
        }
    }
    
    // 타이머 중지
    private func stopTimer() {
        print("카운드 다운 타이머 중지 할거야")
        timer?.invalidate()
        timer = nil
    }
}

//Preview
struct WatchKickOffView_Previews: PreviewProvider {
    static var previews: some View {
        WatchKickOffView(viewModel: HikingViewModel(), timeManager: TimeManager())
    }
}
