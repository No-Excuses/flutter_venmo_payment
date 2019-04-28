#import "VenmoPaymentPlugin.h"
#import <venmo_payment/venmo_payment-Swift.h>

@implementation VenmoPaymentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVenmoPaymentPlugin registerWithRegistrar:registrar];
}
@end
