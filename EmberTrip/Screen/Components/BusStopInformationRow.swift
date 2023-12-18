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
    var hadAlert: Bool
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { _ in
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(getETA(arrive: scheduled))
                            .strikethrough(arrivalState() != .OnTime)
                        Text(getETA(arrive: estimated))
                            .foregroundStyle(arrivalState().color)
                            .opacity(arrivalState() == .OnTime ? 0 : 1)
                    }
                    HStack {
                        Text(location ?? "")
                            .font(.headline)
                        Image(systemName: "bell.and.waves.left.and.right")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow, .blue)
                            .symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
                            .opacity(hadAlert ? 1 : 0)
                    }
                }
                Spacer()
                Text(arrivalState().text)
                    .foregroundStyle(arrivalState().color)
            }
            .opacity(isArrived() ? 0.6 : 1)
            .contentShape(Rectangle())
        }
    }
    
    /// This function calculates the estimated time of arrival (ETA) based on the provided arrival time a returns a formatted string representing the ETA.
    /// - Parameters:
    ///   - arrive: The arrival time as a string.
    /// - Returns: A string representing the ETA. If the arrival time is not available or the calculation cannot be performed, it returns "Unknow". If the showActualTime flag is true, it returns the actual arrival time in "HH:mm" format. If the ETA is less than or equal to 0, it returns "Arrived". Otherwise, it returns the ETA in minutes.
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

    /// This function checks if the estimated arrival time is less than the current time and returns a Boolea   value indicating whether the arrival time has passed.
    /// - Returns: A Boolean value indicating whether the estimated arrival time has passed or not. Returns tru /// if the estimated arrival time is less than the current time, otherwise returns false.
    private func isArrived() -> Bool {
        if let estimated = estimated, let estimatedDate = estimated.toDate() {
            if estimatedDate < Date.now {
                return true
            } else {
                return false
            }
        }
        if let scheduled = scheduled, let scheduledDate = scheduled.toDate() {
            if scheduledDate < Date.now {
                return true
            } else {
                return false
            }
        }
        return false
    }


    private func arrivalState() -> ArrivalState {
        guard let scheduled = scheduled, let scheduledDate = scheduled.toDate() else {
            return .Late
        }
        guard let estimated = estimated, let estimatedDate = estimated.toDate() else {
            return .OnTime
        }
        let diff: Double = estimatedDate.distance(to: scheduledDate)
        // Late < -30 < On Time < 30 < Early
        if diff > 30 {
            return .Early
        } else if diff < -30 {
            return .Late
        }
        return .OnTime
    }
}

enum ArrivalState {
    case Early, OnTime, Late
    
    var color: Color {
        switch self {
        case .Early:
            return .blue
        case .OnTime:
            return .green
        case .Late:
            return .red
        }
    }
    
    var text: String {
        switch self {
        case .Early:
            return "Early"
        case .OnTime:
            return "On Time"
        case .Late:
            return "Late"
        }
    }
}

#Preview {
    BusStopInformationRow(scheduled: "", estimated: "", location: "test", showActualTime: false, hadAlert: false)
}
