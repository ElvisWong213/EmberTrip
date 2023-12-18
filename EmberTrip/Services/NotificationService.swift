//
//  NotificationService.swift
//  EmberTrip
//
//  Created by Elvis on 17/12/2023.
//

import Foundation
import UserNotifications

/// Service responsible for handling notifications and requesting user authorization for notifications.
class NotificationService {
    
    /// Boolean property indicating the authorization status for notifications.
    private var authorizationStatus: Bool
    
    /// Initializes theNotificationService` and sets the initial authorization status `false`. It also calls the methods to get the current authorization state and request authorization.
    init() {
        self.authorizationStatus = false
        getAuthorizationState()
        requestAuthorization()
    }
    
    /// Retrieves the current authorization state for notifications and updates the `authorizationStatus` property accordingly.
    func getAuthorizationState() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self.authorizationStatus = false
            case .authorized, .provisional, .ephemeral:
                self.authorizationStatus = true
            @unknown default:
                self.authorizationStatus = false
            }
        }
    }
    
    /// Requests authorization from the user to display notifications with the specified options and updates the `authorizationStatus` property based on the granted authorization or any error encountered.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .criticalAlert]) { granted, error in
            if let error = error {
                print(error)
                self.authorizationStatus = false
            }
            if granted {
                self.authorizationStatus = true
            }
        }
    }
    
    /// Creates and schedules a notification with the provided title, subtitle, identifier, and date components if the authorization status is `true`.
    /// - Parameters:
    ///    - title: The title of the notification.
    ///    - subtitle: The subtitle of the notification.
    ///    - id: The unique identifier for the notification.
    ///    - date: The date components when the notification should be triggered.
    /// - Returns: A boolean value indicating the success of creating and scheduling the notification.
    func createNotification(title: String, subtitle: String, id: UUID, date: DateComponents) -> Bool {
        guard authorizationStatus else {
            return false
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        return true
    }
    
    /// Removes all pending notification requests from the notification center.
    func removeAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
