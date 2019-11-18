package ch.sonect.sdk;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class SonectCordovaPlugin extends CordovaPlugin {
    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
        Log.e("!@# action performed: ", action);
        if ("present".equalsIgnoreCase(action)) {
            processPresentCommand(args);
        }
        return true;
    }

    private void processPresentCommand(CordovaArgs args) throws JSONException {
        ArrayList<SDKEntryPointActivity.PaymentMethodReference> pms = new ArrayList<>();

        JSONObject credentials = args.getJSONObject(0);
        JSONArray paymentMethods = args.getJSONArray(1);
        JSONObject theme= args.getJSONObject(2);

        for (int i = 0; i < paymentMethods.length(); i++) {
            JSONObject pm = paymentMethods.getJSONObject(i);
            pms.add(new SDKEntryPointActivity.PaymentMethodReference(
                            pm.getString("name"), R.drawable.ic_sonect_web_bank, pm.getString("detailDescription"), (float) pm.getDouble("funds")
                    )
            );
        }

        SDKEntryPointActivity.Companion.start(cordova.getActivity(),
                new SonectSDK.Config.UserCredentials(credentials.getString("userId"),
                        credentials.getString("token"),
                        credentials.getString("signature"), "eu", null),
                pms,
                theme.get("type") == "light",
                SonectSDK.Config.Enviroment.DEV);
    }


}