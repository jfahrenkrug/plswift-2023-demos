//
//  KeyboardFocusableWebView.swift
//  WKWebViewKeyboardFocus
//
//  Created by Johannes Fahrenkrug on 9/8/22.
//

import WebKit

/// A helper class that swizzles a private WebKit method so the keyboard is shown when an input element is focussed programatically.
/// Only changes the behavior for KeyboardFocusableWebView instances that have `keyboardDisplayRequiresUserAction` set to `false`.
/// Based on code from https://stackoverflow.com/a/46029192/171933
class SmartWebViewKeyboardFocusHelper {
    private static var _methodSwizzlingHasBeenAttempted: Bool = false
    
    /// Type of the method that needs to be swizzled
    typealias ElementDidFocusMethodType = @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void
    
    /// Safely apply the fix
    static func applyKeyboardFocusFixIfNeeded() {
        if #available(iOS 16.4, *) {
            print("Running on iOS 16.4 or later, fix not needed.")
            return
        }
        
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
                let overrideBlock : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { (me, arg0, originalUserIsInteracting, arg2, arg3, arg4) in
                    print("calling swizzled method")
                    
                    // Default value pass-through
                    var userIsInteracting = originalUserIsInteracting
                    
                    // Are we a decendant of KeyboardFocusableWebView?
                    if let contentView = me as? UIView, let keyboardFocusableView = contentView.superview(ofType: KeyboardFocusableWebView.self) {
                        userIsInteracting = keyboardFocusableView.keyboardDisplayRequiresUserAction ? originalUserIsInteracting : true
                    }
                    
                    originalTypedImplementation(me, originalMethodSelector, arg0, userIsInteracting, arg2, arg3, arg4)
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

/// A WKWebView that can allow bringing up the keyboard without requiring user action
class KeyboardFocusableWebView: WKWebView {
    private var _keyboardDisplayRequiresUserAction = true
    
    /// When set to false, no user action is required to display the keyboard on focus events. Defaults to `true`.
    var keyboardDisplayRequiresUserAction: Bool {
        get {
            _keyboardDisplayRequiresUserAction
        }
        
        set {
            _keyboardDisplayRequiresUserAction = newValue
            SmartWebViewKeyboardFocusHelper.applyKeyboardFocusFixIfNeeded()
        }
    }
}

extension UIView {
    /// Searches for a superview of the given type and returns it, otherwise nil
    func superview<T: UIView>(ofType type: T.Type) -> T? {
        var view: UIView? = self
        while (view != nil) {
            if let requestedView = view as? T {
                return requestedView
            }
            view = view?.superview
        }
        return nil
    }
}
