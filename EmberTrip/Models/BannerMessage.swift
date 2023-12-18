//
//  BannerMessage.swift
//  EmberTrip
//
//  Created by Elvis on 18/12/2023.
//

import Foundation
import SwiftUI

enum BannerMessage {
    case NetworkError, MoreInfo, SetAlert, RemoveAlert, FailToSetAlert
}

extension BannerMessage {
    var title: String {
        switch self {
        case .NetworkError:
            return "Network Error"
        case .MoreInfo:
            return "Offline Mode Enable"
        case .SetAlert:
            return "Arrival Notification Successfully Set"
        case .RemoveAlert:
            return "Arrival Notification Removed"
        case .FailToSetAlert:
            return "Fail To Set Arrival Notification"
        }
    }
    
    var body: LocalizedStringKey {
        switch self {
        case .NetworkError:
            return "Please check your internet connection and try again later."
        case .MoreInfo:
            return "The Bus Map Offline Mode enables users to access bus routes and information without an internet connection.\n**However, it may not provide accurate information.**"
        case .SetAlert:
            return "It will alert you **5 minutes** before you arrive soon."
        case .RemoveAlert:
            return "Arrival notification removed successfully"
        case .FailToSetAlert:
            return "The arrival notification was not successfully set. Please check if notification permissions are enabled and try again."
        }
    }
    
    var duration: Double {
        switch self {
        case .NetworkError, .SetAlert, .RemoveAlert:
            return 2.5
        case .FailToSetAlert:
            return 3
        case .MoreInfo:
            return 10
        }
    }
    
    var color: Color {
        switch self {
        case .NetworkError, .FailToSetAlert:
            return .red
        case .MoreInfo:
            return .mint
        case .SetAlert:
            return .green
        case .RemoveAlert:
            return .orange
            
        }
    }
    
}
