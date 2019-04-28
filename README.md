# venmo_payment

Flutter Plugin for sending Venmo Requests

# Usage

To initialize Venmo in your dart code, place this somewhere in the beginning:
```dart
import 'package:venmo_payment/venmo_payment.dart';
VenmoPayment.initialize(appId: "####", secret: "********", name: "App Name");
```
Then to create a payment via app switch:
```dart
String venmoResponse = await VenmoPayment.createPayment(
  recipientUsername: 'some-person',
  fineAmount: 1,
  description: 'Testing Venmo from Plugin',
);
```

# iOS

You must add the following 2 key+value pairs to your info.plist

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>venmo####</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>venmo####</string>
    </array>
  </dict>
</array>
```
(replacing #### with you venmo appId) and
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>venmo</string>
</array>
```

You will also need to add the following to your AppDelegate.swift file in order for your app to listen to callbacks from the Venmo app

```swift
override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  if Venmo.sharedInstance().handleOpen(url) {
    return true
  }
  else {
    return false
  }
}
```

# Android

TODO...
