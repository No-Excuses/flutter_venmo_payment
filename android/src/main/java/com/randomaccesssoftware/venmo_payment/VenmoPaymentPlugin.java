package com.randomaccesssoftware.venmo_payment;

import android.app.Activity;
import android.content.Intent;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * VenmoPaymentPlugin
 */
public class VenmoPaymentPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
    private final Activity activity;
    private final int REQUEST_CODE_VENMO_APP_SWITCH = 1215;
    private Result result;
    private String appId;
    private String secret;
    private String name;

    private VenmoPaymentPlugin(Activity activity) {
        this.activity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "venmo_payment");
        VenmoPaymentPlugin plugin = new VenmoPaymentPlugin(registrar.activity());
        channel.setMethodCallHandler(plugin);
        registrar.addActivityResultListener(plugin);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("initializeVenmo")) {
            HashMap arguments = (HashMap) call.arguments;
            this.appId = (String) arguments.get("appId");
            this.secret = (String) arguments.get("secret");
            this.name = (String) arguments.get("name");
            HashMap response = new HashMap();
            response.put("success", true);
            result.success(response);
        } else if (call.method.equals("createVenmoPayment")) {
            if (VenmoLibrary.isVenmoInstalled(activity.getApplicationContext())) {
                this.result = result;
                HashMap arguments = (HashMap) call.arguments;
                String recipientUsername = (String) arguments.get("recipientUsername");
                int amount = (int) arguments.get("amount");
                String note = (String) arguments.get("note");
                Intent venmoIntent = VenmoLibrary.openVenmoPayment(this.appId, this.name, recipientUsername, centsToDollars(amount), note, "pay");
                this.activity.startActivityForResult(venmoIntent, REQUEST_CODE_VENMO_APP_SWITCH);
            } else {
                HashMap response = new HashMap();
                response.put("success", false);
                response.put("error", "Venmo not installed");
                result.success(response);
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_VENMO_APP_SWITCH) {
            HashMap response = new HashMap();
            if (resultCode == Activity.RESULT_OK) {
                String signedRequest = data.getStringExtra("signedrequest");
                if (signedRequest != null) {
                    VenmoLibrary.VenmoResponse venmoResponse = (new VenmoLibrary()).validateVenmoPaymentResponse(signedRequest, this.secret);
                    //Payment successful.  Use data from venmoResponse object to display a success message
                    response.put("id", venmoResponse.getPaymentId());
                    response.put("amount", venmoResponse.getAmount());
                    response.put("success", true);
                } else {
                    //An error ocurred.
                    response.put("success", false);
                    response.put("error", data.getStringExtra("error_message"));
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                //The user cancelled the payment
                response.put("success", false);
                response.put("error", "The transaction was incomplete.");
            }
            this.result.success(response);
            return true;
        } else {
            return false;
        }
    }

    private String centsToDollars(int cents) {
        if (cents >= 100) {
            String stringCents = cents + "";
            return stringCents.substring(0, stringCents.length() - 2) +
                    "." +
                    stringCents.substring(stringCents.length() - 2);
        } else if (cents >= 10) {
            return "0." + cents;
        } else {
            return "0.0" + cents;
        }
    }
}
