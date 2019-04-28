import 'dart:async';

import 'package:flutter/services.dart';

class VenmoPayment {
  static const MethodChannel _channel =
      const MethodChannel('venmo_payment');

  static void initialize({String appId, String secret, String name}) async {
    Map<String, dynamic> params = <String, dynamic> {
      'appId': appId,
      'secret': secret,
      'name': name,
    };
    await _channel.invokeMethod('initializeVenmo', params);
  }

  static Future<String> createPayment({String recipientUsername, int fineAmount, String description}) async {
    Map<String, dynamic> params = <String, dynamic> {
      'recipientUsername': recipientUsername,
      'amount': fineAmount,
      'note': description,
    };
    final String response = await _channel.invokeMethod('createVenmoPayment', params);
    print(response);
    return response;
  }

}
