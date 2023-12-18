//
//  NotificationService.swift
//  EmberTrip
//
//  Created by Elvis on 17/12/2023.
//

import Foundation
import UserNotifications

class NotificationService {
    private var authorizationStatus: Bool
    
    init() {
        self.authorizationStatus = false
        
        getAuthorizationState()
        requestAuthorization()
    }
    
    func getAuthorizationState() {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined, .denied:
                self.authorizationStatus = false
            case .authorized, .provisional, .ephemeral:
                self.authorizationStatus = true
            @unknown default:
                self.authorizationStatus = false
            }
        }
    }
    
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
    
    func removeAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
