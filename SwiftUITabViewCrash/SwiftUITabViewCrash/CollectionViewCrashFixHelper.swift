//
//  CollectionViewCrashFixHelper.swift
//  TabBarCrashTest
//
//  Created by Johannes Fahrenkrug on 5/5/23.
//

import UIKit

/// A helper class that swizzles a private UICollectionView method in order to prevent a SwiftUI crash for empty TabViews.
class CollectionViewCrashFixHelper {
    private static var _methodSwizzlingHasBeenAttempted: Bool = false
    
    /// Type of the method that needs to be swizzled
    typealias ScrollToItemAtIndexPathMethodType = @convention(c) (UICollectionView, IndexPath, Int64, Bool) -> Void
    
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
                let originalTypedImplementation: ScrollToItemAtIndexPathMethodType = unsafeBitCast(originalImplementation, to: ScrollToItemAtIndexPathMethodType.self)
                // Create the new implementation that only calls the original implementation
                // if the requested indexPath is valid.
                let overrideBlock : @convention(block) (UICollectionView, IndexPath, Int64, Bool) -> Void = { (me, indexPath, scrollPosition, animated) in
                    print("calling swizzled method")
                    if (me.numberOfSections > indexPath.section && me.numberOfItems(inSection: indexPath.section) > indexPath.item) {
                        originalTypedImplementation(me, indexPath, scrollPosition, animated)
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

