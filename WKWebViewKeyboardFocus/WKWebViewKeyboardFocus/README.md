# WKWebViewKeyboardFocus Demo

This demo shows how to use method swizzling of a private WebKit method to bring up the keyboard when a text field is focussed through JavaScript instead of a user-initiated action.

## Demo Steps
1. Run demo and show how the keyboard comes up up when tapping the button in the webview, but it doesn't come up when tapping the native button.
2. Show the HTML/JS code.
3. Show the native code in `ViewController.swift` `focusTextField`.
4. It's the same code, why is the keyboard not coming up? (back to slides)
5. The old UIWebView had a property called [`keyboardDisplayRequiresUserAction`]( https://developer.apple.com/documentation/uikit/uiwebview/1617967-keyboarddisplayrequiresuseractio). Implies that WebKit cares about whether an action was triggered by a user interaction or not.
6. First step: Has someone else had this problem? [Google for "wkwebview focus keyboard"](https://www.google.com/search?client=safari&rls=en&q=wkwebview+focus+keyboard&ie=UTF-8&oe=UTF-8). First link: https://stackoverflow.com/questions/32449870/programmatically-focus-on-a-form-in-a-webview-wkwebview
6. Thankfully WebKit is open source.
