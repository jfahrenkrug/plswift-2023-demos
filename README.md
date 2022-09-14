# NSSpain 2022 Demos

This repo contains three demo projects that accompany the talk ["Living dangerously: The why and how of safely using private APIs on iOS"](https://2022.nsspain.com/index.html#schedule) I (Johannes Fahrenkrug) gave at NSSpain 2022.

## WKWebViewKeyboardFocus

This project shows how to use method swizzling to enable a behavior in WKWebView: bringing up the keyboard when programatically focussing an input element.

## ContextMenuCrash

This project shows how to work around a crash on macOS Monterey when right-clicking in a `UITextField`. It also highlights that the fix needs to be implemented in Objective-C because [Swift's error handling behavior](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html#ID512) is different and thus won't catch the thrown exception.

## PushNotificationsTest

This project shows how to instatiate `UNNotification` objects using a private initializer in order to unit test `UNUserNotificationCenterDelegate` methods.

## Thank You

Thank you to the NSSpain organizers for inviting me, thank you to the attendees for kindly and patiently listening to my talk, and thank you to [The Smyth Group](https://thesmythgroup.com) for sponsoring part of the talk preparation.
