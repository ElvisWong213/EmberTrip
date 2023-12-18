//
//  MyNotification.swift
//  EmberTrip
//
//  Created by Elvis on 17/12/2023.
//

import Foundation

struct ArrivalNotification: Codable {
    var id: UUID
    var tripId: String
    var busStopId: Int
}
