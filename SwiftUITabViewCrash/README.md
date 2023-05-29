# SwiftUITabViewCrash Demo

This demo shows how to use method swizzling of a private UIKit method to monkey-patch a crashing bug on iOS 16.0.
The crash happens right after start up when you run the app on iOS 16.0. The bug was fixed by Apple in iOS 16.1.

## Demo Steps

1. Run demo and show the crash.
2. Zoom in on stack trace. `Attempted to scroll the collection view to an out-of-bounds item (0) when there are only 0 items in section 0.`. `[UICollectionView _scrollToItemAtIndexPath:atScrollPosition:animated:]` in `UIKitCore`.
3. What can we do? Buried deep in Apple's framework. Just wait for them to fix it?
4. `CollectionViewCrashFixHelper.applyFixIfNeeded`. Set breakpoint before `if` statement.
5. Show attempt 2 (Swift do/catch). Still crashes! (Swift only catches errors, not exceptions).
6. Objective-C to the rescue!
7. Try again: Works.
