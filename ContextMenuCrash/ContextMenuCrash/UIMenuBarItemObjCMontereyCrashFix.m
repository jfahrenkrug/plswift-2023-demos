//
//  UIMenuBarItemObjCMontereyCrashFix.m
//  ContextMenuCrash
//
//  Created by Johannes Fahrenkrug on 9/8/22.
//


#import "UIMenuBarItemObjCMontereyCrashFix.h"
#import <objc/runtime.h>

static BOOL hasCrashFixBeenApplied = NO;

@implementation UIMenuBarItemObjCMontereyCrashFix

/// Apply the crash fix. It will only be applied the first time it's called, subsequent calls are no-ops.
+ (void)applyCrashFixIfNeeded
{
    if (@available(macOS 12.0, *)) {} else {
        // Bail if we are not running on Monterey
        return;
    }
    
    if (!hasCrashFixBeenApplied) {
        Class UnderscoreUIMenuBarItem = NSClassFromString(@"_UIMenuBarItem");
        SEL selector = sel_getUid("properties");
        Method method = class_getInstanceMethod(UnderscoreUIMenuBarItem, selector);
        IMP original = method_getImplementation(method);
        
        // The crash happens because in some instances the original implementation
        // tries to insert `nil` as a value for the key `title` into a dictionary.
        // This is how the fix works:
        // We wrap the original implementation call in a @try/@catch block. When the
        // exception happens, we catch it, and then return a dummy dictionary to
        // satisfy the caller. The dummy has `isEnabled` to to NO, and `isHidden` set
        // to YES.
        IMP override = imp_implementationWithBlock(^id(id me) {
            @try {
                id res = ((id (*)(id))original)(me);
                return res;
            }
            @catch(NSException *exception) {
                return @{
                    @"allowsAutomaticKeyEquivalentLocalization" : @0,
                    @"allowsAutomaticKeyEquivalentMirroring" : @0,
                    @"defaultCommand" : @0,
                    @"identifier":@"com.apple.menu.application",
                    @"imageAlwaysVisible" : @0,
                    @"isAlternate" : @0,
                    @"isEnabled" : @0,
                    @"isHidden" : @1,
                    @"isSeparatorItem" : @0,
                    @"keyEquivalent" : @"",
                    @"keyEquivalentModifiers" : @0,
                    @"remainsVisibleWhenDisabled" : @0,
                    @"state" : @0,
                    @"title" : @""
                };
            }
        });
        method_setImplementation(method, override);
        
        hasCrashFixBeenApplied = YES;
    }
}

@end
