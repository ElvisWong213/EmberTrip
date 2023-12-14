//
//  String++.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }
}
