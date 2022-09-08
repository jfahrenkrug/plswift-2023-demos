//
//  UIMenuBarItemObjCMontereyCrashFix.h
//  ContextMenuCrash
//
//  Created by Johannes Fahrenkrug on 9/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Helper class to apply a fix to prevent a crash on macOS Monterey when a user right-clicks in a text field
@interface UIMenuBarItemObjCMontereyCrashFix : NSObject

/// Apply the crash fix. It will only be applied the first time it's called, subsequent calls are no-ops.
/// It will only have an effect when called on macOS Monterey or later.
+ (void)applyCrashFixIfNeeded;

@end

NS_ASSUME_NONNULL_END
