package ch.sonect.sdk;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONException;

public class SonectCordovaPlugin extends CordovaPlugin {
    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
        Log.e("!@#", action);
        Log.e("!@#", args.toString());
//        Context applicationContext = cordova.getActivity().getApplicationContext();
//        SDKEntryPointActivity.Companion.start(applicationContext, );
        return true;
    }


}