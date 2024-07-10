//
//  PhoneDetailView.swift
//  LittleHiker
//
//  Created by Hyungeol Lee on 5/17/24.
//

import SwiftUI

struct PhoneDetailView: View {
    //    @Binding var record: HikingRecord
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("산행 제목")
                        .font(.system(size: 34, weight: .bold))
                    Spacer()
                }
                HStack {
                    //                Text("\(record.duration)")
                    Text("5:33:52")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(Color(hex: "FED709"))
                    Spacer()
                }
                HStack {
                    Text("오전 10시 23분 ~ 오후 3시 57분")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                VStack {
                    HStack {
                        Text("하산 충격량 추이")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 361, height: 147)
                        Text("하산 충격량 추이 그래프")
                    }
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("세부 정보")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 361, height: 500)
                        
//                        HStack(spacing: 30) {
//                            VStack {
//                                VStack(alignment: .leading) {
//                                    Text("등산 시간")
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundStyle(Color(hex: "EBEBF5"))
//                                    Text("3:23:42")
//                                        .font(.system(size: 32, weight: .medium))
//                                        .foregroundStyle(Color(hex: "FED709"))
//                                }
//                                VStack(alignment: .leading) {
//                                    Text("총 거리")
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundStyle(Color(hex: "EBEBF5"))
//                                    Text("12.88 KM")
//                                        .font(.system(size: 32, weight: .medium))
//                                        .foregroundStyle(Color(hex: "5AC8FA"))
//                                }
//                                VStack(alignment: .leading) {
//                                    Text("평균 심박수")
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundStyle(Color(hex: "EBEBF5"))
//                                    Text("138 BPM")
//                                        .font(.system(size: 32, weight: .medium))
//                                        .foregroundStyle(Color(hex: "FF3B2F"))
//                                }
//                            }
//
//                            VStack {
//                                VStack(alignment: .leading) {
//                                    Text("하산 시간")
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundStyle(Color(hex: "EBEBF5"))
//                                    Text("2:10:10")
//                                        .font(.system(size: 32, weight: .medium))
//                                        .foregroundStyle(Color(hex: "FED709"))
//                                }
//
//                                VStack(alignment: .leading) {
//                                    Text("평균 속도")
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundStyle(Color(hex: "EBEBF5"))
//                                    Text("4 KM/H")
//                                        .font(.system(size: 32, weight: .medium))
//                                        .foregroundStyle(Color(hex: "02F5EA"))
//                                }
//
//                                VStack(alignment: .leading) {
//                                    Text("등반 고도")
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundStyle(Color(hex: "EBEBF5"))
//                                    Text("665 M")
//                                        .font(.system(size: 32, weight: .medium))
//                                        .foregroundStyle(Color(hex: "00DE70"))
//                                }
//                            }
//                        }
                                                VStack(alignment: .leading, spacing: 20) {
                                                    HStack(spacing: 50) {
                                                        VStack(alignment: .leading) {
                                                            Text("등산 시간")
                                                                .font(.system(size: 16, weight: .medium))
                                                                .foregroundStyle(Color(hex: "EBEBF5"))
                                                            Text("3:23:42")
                                                                .font(.system(size: 32, weight: .medium))
                                                                .foregroundStyle(Color(hex: "FED709"))
                                                        }
                                                        VStack(alignment: .leading) {
                                                            Text("하산 시간")
                                                                .font(.system(size: 16, weight: .medium))
                                                                .foregroundStyle(Color(hex: "EBEBF5"))
                                                            Text("2:10:10")
                                                                .font(.system(size: 32, weight: .medium))
                                                                .foregroundStyle(Color(hex: "FED709"))
                                                        }
                                                    }
                                                    HStack(spacing: 50) {
                                                        VStack(alignment: .leading) {
                                                            Text("총 거리")
                                                                .font(.system(size: 16, weight: .medium))
                                                                .foregroundStyle(Color(hex: "EBEBF5"))
                                                            Text("12.88 KM")
                                                                .font(.system(size: 32, weight: .medium))
                                                                .foregroundStyle(Color(hex: "5AC8FA"))
                                                        }
                                                        VStack(alignment: .leading) {
                                                            Text("평균 속도")
                                                                .font(.system(size: 16, weight: .medium))
                                                                .foregroundStyle(Color(hex: "EBEBF5"))
                                                            Text("4 KM/H")
                                                                .font(.system(size: 32, weight: .medium))
                                                                .foregroundStyle(Color(hex: "02F5EA"))
                                                        }
                                                    }
                                                    HStack(spacing: 50) {
                                                        VStack(alignment: .leading) {
                                                            Text("평균 심박수")
                                                                .font(.system(size: 16, weight: .medium))
                                                                .foregroundStyle(Color(hex: "EBEBF5"))
                                                            Text("138 BPM")
                                                                .font(.system(size: 32, weight: .medium))
                                                                .foregroundStyle(Color(hex: "FF3B2F"))
                                                        }
                                                        VStack(alignment: .leading) {
                                                            Text("등반 고도")
                                                                .font(.system(size: 16, weight: .medium))
                                                                .foregroundStyle(Color(hex: "EBEBF5"))
                                                            Text("665 M")
                                                                .font(.system(size: 32, weight: .medium))
                                                                .foregroundStyle(Color(hex: "00DE70"))
                                                        }
                                                    }
                                                }
                    }
                }
                
            }
        }
        .padding()
    }
}

#Preview {
    PhoneDetailView()
}

