//
//  CollectionViewCrashFixHelper2.swift
//  SwiftUITabViewCrash
//
//  Created by Johannes Fahrenkrug on 5/29/23.
//

import UIKit

/// A helper class that swizzles a private UICollectionView method in order to prevent a SwiftUI crash for empty TabViews. Note: This approach does not work. Only the Obj-C version works.
class CollectionViewCrashFixHelper2 {
    private static var _methodSwizzlingHasBeenAttempted: Bool = false
    
    /// Type of the method that needs to be swizzled
    typealias ScrollToItemAtIndexPathMethodType = @convention(c) (UICollectionView, IndexPath, UInt, Bool) -> Void
    
    /// Type of the method that needs to be swizzled with "throws"
    typealias ScrollToItemAtIndexPathMethodThrowingType = (UICollectionView, IndexPath, UInt, Bool) throws -> Void
    
    /// Safely apply the fix
    static func applyCrashFixIfNeeded() {
        if #available(iOS 16.1, *) {
            print("Running on iOS 16.1 or later, fix not needed.")
            return
        }
        
        if #available(iOS 16.0, *), !_methodSwizzlingHasBeenAttempted {
            print("Running on iOS 16.0, applying fix.")
            
            // See https://headers.cynder.me/index.php?sdk=ios/16.0&fw=/PrivateFrameworks/UIKitCore.framework&file=Headers%2FUICollectionView.h
            let originalSignature = "_scrollToItemAtIndexPath:atScrollPosition:animated:";
            let originalMethodSelector: Selector = sel_getUid(originalSignature)
            
            // Ensure the method we are trying to replace actually exists
            if let method = class_getInstanceMethod(UICollectionView.self, originalMethodSelector) {
                let originalImplementation: IMP = method_getImplementation(method)
                // Create a function constant of the correct type so Swift allows us to invoke it
                let originalTypedImplementation: ScrollToItemAtIndexPathMethodThrowingType = unsafeBitCast(originalImplementation, to: ScrollToItemAtIndexPathMethodType.self)
                
                
                
                
                
                
                
                // Create the new implementation that wraps the call to
                // the original implementation in a do/catch block
                let overrideBlock : @convention(block) (UICollectionView, IndexPath, UInt, Bool) -> Void = { (me, indexPath, scrollPosition, animated) in
                    print("Calling swizzled method")
                    do {
                        try originalTypedImplementation(me, indexPath, scrollPosition, animated)
                    } catch {
                        print("Caught error \(error) and prevented crash.")
                    }
                }
                
                
                
                
                
                
                
                // Create a method implementation with the override block
                let newImplementation: IMP = imp_implementationWithBlock(overrideBlock);
                // Switch out the implementation
                method_setImplementation(method, newImplementation)
            } else {
                print("Method '\(originalSignature)' not found on UICollectionView, aborting")
            }
            
            // Ensure that we only run this once per session
            _methodSwizzlingHasBeenAttempted = true;
        }
    }
}


