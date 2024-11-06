//
//  PhoneDetailView.swift
//  LittleHiker
//
//  Created by Hyungeol Lee on 5/17/24.
//

import SwiftUI
import Charts

struct PhoneDetailView: View {
    @Binding var record: HikingRecord
    
    //충격량 추이 그래프 샘플 데이터
    let sampleData: [ImpluseValues] = generateSampleData()
    
    //Grid 그리기용 컬럼
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("\(record.title)")
                        .font(.system(size: 34, weight: .bold))
                    Spacer()
                }
                HStack {
                    Text("\(record.formattedDurationTime)")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(Color(hex: "FED709"))
                    Spacer()
                }
                HStack {
                    Text("\(record.formattedStartTime) ~ \(record.formattedEndTime)")
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
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 361, height: 147)
                        .overlay {
                            Chart {
                                ForEach(sampleData) { data in
                                    RectangleMark(
                                        x: .value("time", data.minutes),
                                        y: .value("impulse", data.impulse),
                                        width: .ratio(0.5)
                                    )
                                    .foregroundStyle(data.impulse > 70 ? .red : .gray)
                                }
                                RuleMark(
                                    y: .value("expectedImpulse", 70)
                                )
                                .foregroundStyle(.green)
                            }
                            .padding()
                            .chartYAxis {
                                AxisMarks(position: .leading)
                            }
                            .chartYScale(domain: 0 ... 100)
                            .chartXAxis(.hidden)
                            .chartPlotStyle { plotArea in
                                plotArea
                                    .background(.white.opacity(0.1))
                            }
                        }
                }
                .padding(.bottom, 20)
                
                VStack {
                    HStack {
                        Text("세부 정보")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("등산 시간")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color(hex: "EBEBF5"))
                            Text("\(record.formattedDurationTime)")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color(hex: "FED709"))
                        }
                        VStack(alignment: .leading) {
                            Text("하산 시간")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color(hex: "EBEBF5"))
                            //FIXME: 하산 시간에 해당하는 변수가 없음. 정상 시간 받아와서 계산해야 함
                            Text("\(record.formattedDurationTime)")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color(hex: "FED709"))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("총 거리")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color(hex: "EBEBF5"))
                            //FIXME: 총거리에 해당하는 변수 필요함
                            Text("12.88 KM")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color(hex: "5AC8FA"))
                        }
                        VStack(alignment: .leading) {
                            Text("평균 속도")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color(hex: "EBEBF5"))
                            //FIXME: 등반시의 평균 속도임
                            Text("\(record.ascendAvgSpeed) KM/H")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color(hex: "02F5EA"))
                        }
                        VStack(alignment: .leading) {
                            Text("평균 심박수")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color(hex: "EBEBF5"))
                            Text("\(record.avgHeartRate) BPM")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color(hex: "FF3B2F"))
                        }
                        VStack(alignment: .leading) {
                            Text("등반 고도")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color(hex: "EBEBF5"))
                            Text("\(record.peakAltitude) M")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color(hex: "00DE70"))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.2))
                    )
                }
            }
            
        }
        
        .padding()
    }
}

#Preview {
//    PhoneDetailView(record: .constant(HikingRecord.sampleData[0]))
}


//-------- 충격량 그래프용 임시 데이터---------
// ImpluseValues 구조체 정의
struct ImpluseValues: Identifiable {
    let id: String
    let minutes: String
    let impulse: Int
}

// 시간 생성기 (10:36 ~ 12:57)
func generateTimeData() -> [String] {
    var times: [String] = []
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    // 시작 시간과 종료 시간 정의
    var currentTime = dateFormatter.date(from: "10:36")!
    let endTime = dateFormatter.date(from: "12:57")!
    
    // 3분씩 증가하며 시간 추가
    while currentTime <= endTime {
        times.append(dateFormatter.string(from: currentTime))
        currentTime = Calendar.current.date(byAdding: .minute, value: 3, to: currentTime)!
    }
    
    return times
}

func generateSampleData() -> [ImpluseValues] {
    // 샘플 데이터 생성
    let times = generateTimeData()
    var sampleData: [ImpluseValues] = []
    
    for time in times {
        let randomImpulse = Int.random(in: 50...85) // 25에서 85 사이의 랜덤 값 생성
        let newData = ImpluseValues(id: UUID().uuidString, minutes: time, impulse: randomImpulse)
        sampleData.append(newData)
    }
    
    // 데이터 출력 테스트
    for data in sampleData {
        print("ID: \(data.id), Time: \(data.minutes), Impulse: \(data.impulse)")
    }
    
    print("총 \(sampleData.count)개의 샘플 데이터가 생성되었습니다.")
    
    return sampleData
}
