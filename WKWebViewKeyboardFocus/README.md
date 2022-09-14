# WKWebViewKeyboardFocus Demo

This demo shows how to use method swizzling of a private WebKit method to bring up the keyboard when a text field is focussed through JavaScript instead of a user-initiated action.

## Demo Steps

1. Run demo and show how the keyboard comes up up when tapping the button in the webview, but it doesn't come up when tapping the native button.
2. Show the HTML/JS code.
3. Show the native code in `ViewController.swift` `focusTextField`.
4. It's the same code, why is the keyboard not coming up? (back to slides)
5. The old deprecated UIWebView had a property called [`keyboardDisplayRequiresUserAction`]( https://developer.apple.com/documentation/uikit/uiwebview/1617967-keyboarddisplayrequiresuseractio). That implies that WebKit cares about whether an action was triggered by a user interaction or not.
6. First step: Has someone else had this problem? [Google for "wkwebview focus keyboard"](https://www.google.com/search?client=safari&rls=en&q=wkwebview+focus+keyboard&ie=UTF-8&oe=UTF-8). First link: https://stackoverflow.com/questions/32449870/programmatically-focus-on-a-form-in-a-webview-wkwebview
7. Thankfully WebKit is open source. (back to slides)
8. Add `WebViewKeyboardFocusHelper.applyKeyboardFocusFixIfNeeded()` to `ViewController` and run again: Works! But we have a side effect: Tapping anywhere in the webview now brings up the keyboard.
9. Set breakpoint in KeyboardFocusableWebView's swizzled block. Inspect `me` in lldb. Inspect `me.superview.superview`.
10. If we subclass `WKWebView`, we could inspect the instance in the swizzled method and then only selectively override the default behavior.
11. Remove `WebViewKeyboardFocusHelper.applyKeyboardFocusFixIfNeeded()`, and use Snippet 2.
12. Run again: Everything works as expected.

## Snippet 1

```
WebViewKeyboardFocusHelper.applyKeyboardFocusFixIfNeeded()
```

## Snippet 2

```
private let webView: KeyboardFocusableWebView = {
    let webView = KeyboardFocusableWebView(frame: .zero)
    webView.translatesAutoresizingMaskIntoConstraints = false
    return webView
}()

private func focusTextField() {
    webView.keyboardDisplayRequiresUserAction = false
    webView.evaluateJavaScript("document.getElementById('textfield').focus()") { [weak self] res, error in
        print("JS evaluated.")
        self?.webView.keyboardDisplayRequiresUserAction = true
        
        if let res = res {
            print("Res: \(res)")
        }
        
        if let error = error {
            print("Error: \(error)")
        }
    }
}
```
