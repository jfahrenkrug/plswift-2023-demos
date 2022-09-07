//
//  WebViewKeyboardFocusHelper.swift
//  WKWebViewKeyboardFocus
//
//  Created by Johannes Fahrenkrug on 9/7/22.
//

import UIKit
import WebKit

/// A helper class that swizzles a private WebKit method so the keyboard is shown when an input element is focussed programatically.
/// Based on code from https://stackoverflow.com/a/46029192/171933
class WebViewKeyboardFocusHelper {
    private static var _methodSwizzlingHasBeenAttempted: Bool = false
    
    /// Type of the method that needs to be swizzled
    typealias ElementDidFocusMethodType = @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void
    
    /// Safely apply the fix
    static func applyKeyboardFocusFixIfNeeded() {
        if !_methodSwizzlingHasBeenAttempted {
            guard let contentViewClass: AnyClass = NSClassFromString("WKContentView") else {
                print("WKContentView class is not defined, aborting")
                return
            }
            
            // Original method selector for iOS 13.0 and above
            // Source of the method: https://github.com/WebKit/WebKit/blob/548422a12918d9a17699cc93f3cf813e7fca1205/Source/WebKit/UIProcess/ios/WKContentViewInteraction.mm#L6757
            let originalSignature = "_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:";
            let originalMethodSelector: Selector = sel_getUid(originalSignature)
            
            // Ensure the method we are trying to replace actually exists
            if let method = class_getInstanceMethod(contentViewClass, originalMethodSelector) {
                let originalImplementation: IMP = method_getImplementation(method)
                // Create a function constant of the correct type so Swift allows us to invoke it
                let originalTypedImplementation: ElementDidFocusMethodType = unsafeBitCast(originalImplementation, to: ElementDidFocusMethodType.self)
                // Create the new implementation that simply wraps the original and always passes in `true` for `userIsInteracting`.
                let overrideBlock : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3, arg4) in
                    print("calling swizzled method")
                    originalTypedImplementation(me, originalMethodSelector, arg0, true, arg2, arg3, arg4)
                }
                // Create a method implementation with the override block
                let newImplementation: IMP = imp_implementationWithBlock(overrideBlock);
                // Switch out the implementation
                method_setImplementation(method, newImplementation)
            } else {
                print("Method '\(originalSignature)' not found on WKContentView, aborting")
            }
            
            // Ensure that we only run this once per session
            _methodSwizzlingHasBeenAttempted = true;
        }
    }
}
