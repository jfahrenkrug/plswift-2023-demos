//
//  PushNotificationService.swift
//  PushNotificationsTest
//
//  Created by Johannes Fahrenkrug on 9/9/22.
//

import Foundation
import UIKit
import UserNotifications
import Combine
import os.log


/// Service to handle push notifications
class PushNotificationService: NSObject {
    
    /// Publishes new received push notifications
    let notificationsPublisher = PassthroughSubject<UNNotification, Never>()
}

extension PushNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        notificationsPublisher.send(notification)
        completionHandler(.init(arrayLiteral: [.list, .banner, .sound]))
    }
}

