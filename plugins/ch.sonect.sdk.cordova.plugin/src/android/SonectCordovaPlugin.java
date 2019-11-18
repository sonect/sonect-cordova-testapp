package ch.sonect.sdk;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

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
            processPresentCommand(args);
        } else if ("presentTransaction".equalsIgnoreCase(action)) {
            processPresentTransactionCommand(args);
        }
        return true;
    }

    private void processInitCommand(CordovaArgs args) throws JSONException {
        JSONObject credentials = args.getJSONObject(0);
        JSONArray paymentMethods = args.getJSONArray(1);
        JSONObject theme = args.getJSONObject(2);

        PAYMENT_METHODS = new ArrayList<>();
        for (int i = 0; i < paymentMethods.length(); i++) {
            JSONObject pm = paymentMethods.getJSONObject(i);
            PAYMENT_METHODS.add(new SDKEntryPointActivity.PaymentMethodReference(
                            pm.getString("name"), R.drawable.ic_sonect_web_bank, pm.getString("detailDescription"), (float) pm.getDouble("funds")
                    )
            );
        }

        CREDENTIALS = new SonectSDK.Config.UserCredentials(credentials.getString("userId"),
                credentials.getString("token"),
                credentials.getString("signature"), "eu", null);

        IS_LIGHT_THEME = theme.get("type") == "light";
    }

    private void processPresentCommand(CordovaArgs args) throws JSONException {
        SDKEntryPointActivity.Companion.start(cordova.getActivity(), CREDENTIALS,
                PAYMENT_METHODS, IS_LIGHT_THEME, SonectSDK.Config.Enviroment.DEV);
    }

    private void processPresentTransactionCommand(CordovaArgs args) throws JSONException {
        JSONObject paymentRef = args.getJSONObject(0);

        String uniqueID = null;
        if (paymentRef.has("uniqueIdentifier")) {
            uniqueID = paymentRef.getString("uniqueIdentifier");
        }
        SDKEntryPointActivity.Companion.startWithdraw(cordova.getActivity(), CREDENTIALS,
                new SDKEntryPointActivity.NewTransactionReference(paymentRef.getString("paymentReference"), uniqueID,
                        paymentRef.getString("value"), paymentRef.getString("currency")),
                PAYMENT_METHODS, IS_LIGHT_THEME, SonectSDK.Config.Enviroment.DEV);
    }
}