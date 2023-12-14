//
//  BusStopInformationRow.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import SwiftUI

struct BusStopInformationRow: View {
    let scheduled: String?
    let estimated: String?
    let location: String?
    var showActualTime: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(getETA(arrive: scheduled))
                        .strikethrough(!isOnTime())
                    Text(getETA(arrive: estimated))
                        .foregroundStyle(isOnTime() ? .green : .red)
                        .opacity(isOnTime() ? 0 : 1)
                }
                Text(location ?? "")
                    .font(.headline)
            }
            Spacer()
            Text(isOnTime() ? "On Time" : "Late")
                .foregroundStyle(isOnTime() ? .green : .red)
        }
        .opacity(isArrived(arrive: estimated) ? 0.6 : 1)
    }
    
    private func getETA(arrive: String?) -> String {
        guard let arrive = arrive, let arriveDate = arrive.toDate() else {
            return "Unknow"
        }
        if showActualTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: arriveDate)
        }
        let minute = Int((Date.now.distance(to: arriveDate) / 60).rounded())
        if minute <= 0 {
            return "Arrived"
        }
        return String(minute) + " min"
    }
    
    private func isArrived(arrive: String?) -> Bool {
        guard let arrive = arrive, let arriveDate = arrive.toDate() else {
            return false
        }
        if arriveDate < Date.now {
            return true
        }
        return false
    }
    
    private func isOnTime() -> Bool {
        guard let scheduled = scheduled, let scheduledDate = scheduled.toDate() else {
            return false
        }
        guard let estimated = estimated, let estimatedDate = estimated.toDate() else {
            return true
        }
        if estimatedDate <= scheduledDate {
            return true
        }
        return false
    }
}

#Preview {
    BusStopInformationRow(scheduled: "", estimated: "", location: "test", showActualTime: false)
}
