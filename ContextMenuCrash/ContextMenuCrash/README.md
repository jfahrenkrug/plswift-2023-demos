# ContextMenuCrash Demo

This demo shows how to use method swizzling of a private UIKit method to monkey-patch a crashing bug on macOS Monterey.
The crash happens when you run the app with "My Mac (Designed for iPad)" as the run destination and you simply right-click (option-click) in the text field.

## Demo Steps
1. Run demo and show the crash.
2. Zoom in on stack trace. Attempting to insert nil into a dictionary for key "title". `[_UIMenuBarItem properties]` in `UIKitCore`.
3. What can we do? Buried deep in Apple's framework. Just wait for them to fix it?
4. UIMenuBarItemMontereyCrashFix.applyFixIfNeeded. Set breakpoint in result and inspect it (po result).
5. Surround with do/catch and try again. Still crashes! (Swift only catches errors, not exceptions).
6. Objective-C to the rescue!
7. Try again: Works.
