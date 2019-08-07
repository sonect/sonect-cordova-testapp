package ch.sonect.sdk;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONException;

import java.util.ArrayList;

public class SonectCordovaPlugin extends CordovaPlugin {
    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
        if ("present".equalsIgnoreCase(action)) {
            ArrayList<SDKEntryPointActivity.PaymentMethodReference> pms = new ArrayList<>(1);
            // TODO define JS interface with NEON and then provide valid payment method
            pms.add(new SDKEntryPointActivity.PaymentMethodReference(
                            "My payment method", R.drawable.ic_visa, "**** 1234", 302.44f
                    )
            );
            SDKEntryPointActivity.Companion.start(cordova.getActivity(),
                    new SonectSDK.Config.UserCredentials(args.getString(1),
                            args.getString(0), args.getString(2), null), pms);
        }
        return true;
    }


}