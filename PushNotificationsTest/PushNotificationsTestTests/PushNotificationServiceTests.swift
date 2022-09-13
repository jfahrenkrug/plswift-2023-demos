//
//  PushNotificationsTestTests.swift
//  PushNotificationsTestTests
//
//  Created by Johannes Fahrenkrug on 9/9/22.
//

import XCTest
import Combine
@testable import PushNotificationsTest

class PushNotificationServiceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = Set()

    func testNotificationsPublisher() throws {
        let pushService = PushNotificationService()
        
        // Create the notification content
        let notification = createPushNotification(title: "Test", userInfo: ["someKey": "someValue"])
        
        // Test the method
        
        // Expect the publisher to publish
        let publisherExpectation = XCTestExpectation(description: "Publish")
        pushService.notificationsPublisher.sink { note in
            XCTAssertEqual(note, notification)
            publisherExpectation.fulfill()
        }.store(in: &cancellables)
        
        let callbackExpectation = XCTestExpectation(description: "Callback")
        pushService.userNotificationCenter(UNUserNotificationCenter.current(), willPresent: notification) { (options) in
            XCTAssertEqual(options, .init(arrayLiteral: [.list, .banner, .sound]))
            callbackExpectation.fulfill()
        }
        
        wait(for: [callbackExpectation, publisherExpectation], timeout: 2.0)
    }
    
    private func createPushNotification(title: String, userInfo: [AnyHashable: Any]) -> UNNotification {
        // Create the notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.userInfo = userInfo
        
        // Create a notification request with the content
        let notificationRequest = UNNotificationRequest(identifier: "test", content: notificationContent, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false))
        
        // Use private method to create a UNNotification from the request
        // See https://headers.cynder.me/index.php?sdk=ios/15.4&fw=/Frameworks/UserNotifications.framework&file=%2FHeaders%2FUNNotification.h
        let selector = NSSelectorFromString("notificationWithRequest:date:")
        let unmanaged = UNNotification.perform(selector, with: notificationRequest, with: Date())
        let notification = unmanaged?.takeUnretainedValue() as! UNNotification
        
        return notification
    }

}
