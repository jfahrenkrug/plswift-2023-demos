# plSwift 2023 Demos

This repo contains three demo projects that accompany the talk ["Living dangerously: The why and how of safely using private APIs on iOS"](https://plswift.com) I (Johannes Fahrenkrug) gave at plSwift 2023.

## WKWebViewKeyboardFocus

This project shows how to use method swizzling to enable a behavior in WKWebView: bringing up the keyboard when programatically focussing an input element.

## SwiftUITabViewCrash

This project shows how to work around a crash on iOS 16.0 when a SwiftUI `TabView` has no data to display. It also highlights that the fix needs to be implemented in Objective-C because [Swift's error handling behavior](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html#ID512) is different and thus won't catch the thrown exception.

## PushNotificationsTest

This project shows how to instatiate `UNNotification` objects using a private initializer in order to unit test `UNUserNotificationCenterDelegate` methods.

## Thank You

Thank you to the plSwift organizers for inviting me, thank you to the attendees for kindly and patiently listening to my talk, and thank you to [The Smyth Group](https://thesmythgroup.com) for sponsoring part of the talk preparation.
