//
//  UIMenuBarItemMontereyCrashFix.swift
//  ContextMenuCrash
//
//  Created by Johannes Fahrenkrug on 9/8/22.
//

import UIKit

/// A helper class that swizzles a private UIKitCore method to fix a crash on macOS Monterey when right-clicking in a text field
class UIMenuBarItemSwiftMontereyCrashFix {
    private static var _methodSwizzlingHasBeenAttempted: Bool = false
    
    /// Type of the method that needs to be swizzled
    typealias PropertiesMethodType = @convention(c) (Any) -> Dictionary<String, Any>
    typealias PropertiesMethodThrowingType = (Any) throws -> Dictionary<String, Any>
    
    /// Safely apply the fix
    static func applyIfNeeded() {
        if !_methodSwizzlingHasBeenAttempted {
            
            guard #available(macOS 12.0, *) else {
                // Bail if we are not running on Monterey or higher
                return;
            }
            
            guard let menuBarItemClass: AnyClass = NSClassFromString("_UIMenuBarItem") else {
                print("_UIMenuBarItem class is not defined, aborting")
                return
            }

            let originalMethodSelector: Selector = sel_getUid("properties")
            
            // Ensure the method we are trying to replace actually exists
            if let method = class_getInstanceMethod(menuBarItemClass, originalMethodSelector) {
                let originalImplementation: IMP = method_getImplementation(method)
                // Create a function constant of the correct type so Swift allows us to invoke it
                let originalTypedImplementation: PropertiesMethodThrowingType = unsafeBitCast(originalImplementation, to: PropertiesMethodType.self)
                // Create the new implementation that simply wraps the original and always passes in `true` for `userIsInteracting`.
                let overrideBlock : @convention(block) (Any) -> Dictionary<String, Any> = { (me) in
                    print("calling swizzled method")
                    do {
                        let result = try originalTypedImplementation(me)
                        return result
                    } catch {
                        return [:]
                    }
                }
                // Create a method implementation with the override block
                let newImplementation: IMP = imp_implementationWithBlock(overrideBlock);
                // Switch out the implementation
                method_setImplementation(method, newImplementation)
            } else {
                print("Method 'properties' not found on _UIMenuBarItem, aborting")
            }
            
            // Ensure that we only run this once per session
            _methodSwizzlingHasBeenAttempted = true;
        }
    }
}
