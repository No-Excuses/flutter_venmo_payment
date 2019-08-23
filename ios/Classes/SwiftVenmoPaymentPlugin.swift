import Flutter
import UIKit
import Unofficial_Venmo_iOS_SDK

public class SwiftVenmoPaymentPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "venmo_payment", binaryMessenger: registrar.messenger())
    let instance = SwiftVenmoPaymentPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "initializeVenmo") {
      Venmo.initialize()

      let arguments = call.arguments as! [String:Any]
      let appId = arguments["appId"]  as! String
      let secret = arguments["secret"]  as! String
      let name = arguments["name"]  as! String
      if Venmo.isVenmoAppInstalled() && !Venmo.start(withAppId: appId, secret: secret, name: name) {
        Venmo.sharedInstance().requestPermissions([VENPermission.init(type: VENPermissionType.makePayments)], withCompletionHandler: nil)
        Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.appSwitch

        if Venmo.sharedInstance().shouldRefreshToken() || Venmo.sharedInstance().isSessionValid() {
          Venmo.sharedInstance().refreshToken(completionHandler: nil)
        }
      }
      var responseParams = [String: Any] ()
      responseParams["success"] = true
    } else if (call.method == "createVenmoPayment") {
      if (Venmo.isVenmoAppInstalled()) {
        let arguments = call.arguments as! [String:Any]
        let recipientUsername = arguments["recipientUsername"]  as! String
        let amount = arguments["amount"]  as! UInt
        let note = arguments["note"]  as! String
        Venmo.sharedInstance()?.sendPayment (to: recipientUsername,
            amount: amount,
            note: note,
            audience: VENTransactionAudience.userDefault,
            completionHandler: { (transaction, success, error) in
              var responseParams = [String: Any] ()
              responseParams["amount"] = transaction?.target?.amount ?? ""
              responseParams["id"] = transaction?.transactionID ?? ""
              responseParams["error"] = (error)?.localizedDescription ?? ""
              responseParams["success"] = success
              result (responseParams)
            })
      } else {
        var responseParams = [String: Any] ()
        responseParams["success"] = false
        responseParams["error"] = "Venmo not installed"
        result(responseParams)
      }
    } else {
      result("Error: Invalid method call")
    }
  }

}
