//
//  CollectionViewObjCCrashFixHelper.m
//  SwiftUITabViewCrash
//
//  Created by Johannes Fahrenkrug on 5/29/23.
//

@import UIKit;
#import "CollectionViewObjCCrashFixHelper.h"
#import <objc/runtime.h>

static BOOL hasCrashFixBeenApplied = NO;

@implementation CollectionViewObjCCrashFixHelper

/// Apply the crash fix. It will only be applied the first time it's called, subsequent calls are no-ops.
+ (void)applyCrashFixIfNeeded
{
    if (@available(iOS 16.1, *)) {
        NSLog(@"Running on iOS 16.1 or later, fix not needed.");
        return;
    }
    
    if (@available(iOS 16.0, *)) {} else {
        // Bail if we are not running on iOS 16.0
        return;
    }
    
    if (!hasCrashFixBeenApplied) {
        SEL selector = sel_getUid("_scrollToItemAtIndexPath:atScrollPosition:animated:");
        Method method = class_getInstanceMethod(UICollectionView.class, selector);
        IMP original = method_getImplementation(method);
        
        // We wrap the original implementation call in a @try/@catch block. When the
        // exception happens, we catch it and prevent the crash.
        IMP override = imp_implementationWithBlock(^void(id collectionView, NSIndexPath *indexPath, NSUInteger scrollPosition, BOOL animated) {
            @try {
                ((void (*)(id, SEL, NSIndexPath *, NSUInteger, BOOL))original)(collectionView, selector, indexPath, scrollPosition, animated);
            }
            @catch(NSException *exception) {
                NSLog(@"Caught exception %@ and prevented crash.", exception);
                return;
            }
        });
        method_setImplementation(method, override);
        
        hasCrashFixBeenApplied = YES;
    }
}

@end
