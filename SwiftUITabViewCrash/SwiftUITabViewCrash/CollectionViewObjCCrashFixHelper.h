//
//  CollectionViewObjCCrashFixHelper.h
//  SwiftUITabViewCrash
//
//  Created by Johannes Fahrenkrug on 5/29/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A helper class that swizzles a private UICollectionView method in order to prevent a SwiftUI crash for empty TabViews.
@interface CollectionViewObjCCrashFixHelper : NSObject

/// Apply the crash fix. It will only be applied the first time it's called, subsequent calls are no-ops.
/// It will only have an effect when called on iOS 16.0.
+ (void)applyCrashFixIfNeeded;

@end

NS_ASSUME_NONNULL_END
