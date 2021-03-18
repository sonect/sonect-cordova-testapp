package ch.sonect.sdk;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;

public class SonectCordovaPlugin extends CordovaPlugin {

    private static boolean IS_LIGHT_THEME;
    private static ArrayList<SDKEntryPointActivity.PaymentMethodReference> PAYMENT_METHODS;
    private static SonectSDK.Config.UserCredentials CREDENTIALS;

    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
        if (!("init".equalsIgnoreCase(action)) && CREDENTIALS == null) {
            throw new IllegalStateException("Call init() first");
        }
        if ("init".equalsIgnoreCase(action)) {
            processInitCommand(args);
        } else if ("present".equalsIgnoreCase(action)) {
            processPresentCommand();
        } else if ("presentTransaction".equalsIgnoreCase(action)) {
            processPresentTransactionCommand(args);
        }
        return true;
    }

    private void processInitCommand(CordovaArgs args) throws JSONException {
        JSONObject credentials = args.getJSONObject(0);
        JSONArray paymentMethods = args.getJSONArray(1);
        JSONObject theme = args.getJSONObject(2);

        PAYMENT_METHODS = new ArrayList<SDKEntryPointActivity.PaymentMethodReference>();
        for (int i = 0; i < paymentMethods.length(); i++) {
            JSONObject pm = paymentMethods.getJSONObject(i);
            PAYMENT_METHODS.add(new SDKEntryPointActivity.PaymentMethodReference(
                    pm.getString("name"), R.drawable.sonect_ic_sonect_web_bank, "**** 1234", (float) pm.getDouble("funds")
            ));
        }

        CREDENTIALS = new SonectSDK.Config.UserCredentials(credentials.getString("userId"),
                credentials.getString("token"),
                credentials.getString("signature"),
                Collections.emptyMap());

        IS_LIGHT_THEME = theme.get("type") == "light";
    }

    private void processPresentCommand() {
        SDKEntryPointActivity.Companion.start(
                cordova.getActivity(),
                CREDENTIALS,
                PAYMENT_METHODS,
                IS_LIGHT_THEME,
                SonectSDK.Config.Enviroment.DEV
        );
    }

    private void processPresentTransactionCommand(CordovaArgs args) throws JSONException {
        JSONObject paymentRef = args.getJSONObject(0);

        SDKEntryPointActivity.Companion.startWithdraw(
                cordova.getActivity(), CREDENTIALS,
                new SDKEntryPointActivity.NewTransactionReference(
                        "BALANCE", "**** 1234", paymentRef.getString("value"), paymentRef.getString("currency"), null
                ),
                PAYMENT_METHODS,
                IS_LIGHT_THEME,
                SonectSDK.Config.Enviroment.DEV
        );
    }
}