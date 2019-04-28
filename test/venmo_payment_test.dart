import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venmo_payment/venmo_payment.dart';

void main() {
  const MethodChannel channel = MethodChannel('venmo_payment');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    //expect(await VenmoPayment.platformVersion, '42');
  });
}
