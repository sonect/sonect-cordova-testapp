# sonect-cordova-plugin
This is the repo for Cordova SDK

## Installation
To integrate the plugin: 
- clone repo to `YOUR_DIRECTORY`
- `cordova plugin add YOUR_DIRECTORY`

## Integration
To initialize and present the plugin add the following to your .js codebase. 
Additional documentation regarding credentials, themeing and 
payment methods is available [here](https://github.com/sonect/sonect-sdk-ios)

Check out the [Sample App](https://github.com/sonect/sonect-cordova-testapp) for an in depth implementation example. 

```
openSonect: function() {
    let credentials = {
        token: "YOUR_SDK_TOKEN",
        userId: "YOUR_USER_ID",
        signature: "YOUR_SIGNATURE"
    };

    let theme = {
        "type": "light",
        "detailColor1": "048b54",
        "detailColor2": "048b54",
        "detailColor3": "048b54",
        "detailColor4": "048b54",
        "detailColor5": "048b54",
        "navigationBarTintColor": "048b54",
        "navigationBarTitleImage": "Bank"
    };

    // Configure an array of payment methods with the metadata to be displayed in Withdraw screen
    let paymentMethods = [
        {
        uniqueIdentifier: "IBAN_1",
        name: "My Bank",
        detailDescription: "Balance: 20CHF",
        image: "Bank"
        },
    ];

    sonect.init(credentials, paymentMethods, theme);

    // Present the sonect SDK with the credentials obtained from your server, payment methods and a theme
    sonect.present(
        // When the user selects a payment method, this callback is asked if that payment method
        // has enough balance to process the transaction. If this is less than the picked value
	// then the Confirm button with be greyed out. uniqueIdentifier is the identifier of the payment
        // method that you passed when configuring the payment methods. 
        function(uniqueIdentifier, balanceCallback) {
     
            let balance = {
                uniqueIdentifier: uniqueIdentifier,
                value: "100.00",
                currency: "CHF"
            };
            balanceCallback(balance);
        },
	// This callback is called when user pressed Confirm in the Withdraw screen. 
	// It will pass back the uniqueIdentifier of the payment method, the value and the currency
 	// of the requested amount to be withdrawn. 
        function(uniqueIdentifier, value, currency, paymentCallback) {
            // 1. 
            // To process payment without leaving the SDK, follow this code path. 
	    // This will immediately present the Barcode screen. 
	    // You can also call the paymentCallback asynchronously.
            // let paymentReference = {
            //     uniqueIdentifier: uniqueIdentifier,
            //     paymentReference: "PAYMENT_REFERENCE"
            // };
            // paymentCallback(paymentReference);

            //2. 
	    //Alternatively, hide the SDK, and call sonect.pay when you have obtained the payment reference
	    //by processing it in your own UI. 
            sonect.hide(null, null);
            app.paymentUniqueIdentifier = uniqueIdentifier;
        },
        function(msg) {
        },
        function(err) {
        }
    )
},

paySonect: function() {  
    // The payment reference object needs to contain the uniqueIdentifier for the payment method that
    // is supposed to process the transaction. Also you should pass the paymentReference obtained  
    // from your server. 
    let paymentReference = {
        value: "20.00",
        currency: "CHF",
        uniqueIdentifier: app.paymentUniqueIdentifier,
        paymentReference: "YOUR_PAYMENT_REFERENCE"
    };
  
    // This method will present the Sonect SDK in the Barcode screen. 
    sonect.presentTransaction(paymentReference, 
        function(msg) {
        },
        function(err) {
        }
    );
}
```

## Platform specific configuration
### iOS
To configure the iOS SDK do the following steps: 
- `open YOUR_CORDOVA_APP/platforms/ios/YOUR_PROJECT.workspace` in Xcode
- in Xcode, right click on the Resources folder and pick `New File...` from the menu
- pick `Property List`, and name it `SonectConfiguration`
- enter the values as following
```
<dict>
	<key>SonectAlpha2CountryCode</key>
	<string>ch</string>
	<key>SonectCurrency</key>
	<string>CHF</string>
	<key>SonectDefaultWithdrawAmountIndex</key>
	<integer>2</integer>
	<key>SonectAllowedCountryCodes</key>
	<array>
		<integer>41</integer>
	</array>
	<key>SonectEnvironment</key>
	<string>TEST</string>
</dict>
```
- to change to `PROD` environment, remove the `SonectEnvironment` key. 

### Android
#### Restrictions
Android can't properly communicate with underneath Cordova Activity and Sonect plugin when Sonect Activity is opened. OS could kill any activity that is not visible and in this case Android SDK will loose parent handler.

Because of this we just launch Sonect Activity and wait for result.

#### Dependencies

In order to simplify integration Jetifier and AndroidX should be enabled in your Android app. In `gradle.properties` it looks:

```
android.useAndroidX=true
android.enableJetifier=true
```

Sonect Cordova Plugin depends on nativ implementation of Sonect Android SDK, dependencies in plugin:

```
   implementation ('com.github.sonect:android-user-sdk:1.0.10') {
       exclude group: "idenfySdk"
       exclude group: "io.anyline"
   }
```

#### Implementation

Cordova activity must implement `onActivityResult` method and handle withdrawal request.

```
    if (requestCode == SDKEntryPointActivity.REQUEST_CODE) {
        if (resultCode == SDKEntryPointActivity.RESULT_WITHDRAW) {
            Toast.makeText(this,
                    "Requested :" + intent.getIntExtra(SDKEntryPointActivity.AMOUNT_TO_WITHDRAW, -1),
                    Toast.LENGTH_SHORT).show();
        }
    }
```

Android Sonect SDK stores user's context just inside plugin:

```
    private static boolean IS_LIGHT_THEME;
    private static ArrayList<SDKEntryPointActivity.PaymentMethodReference> PAYMENT_METHODS;
    private static SonectSDK.Config.UserCredentials CREDENTIALS;
```

As per test this data should persist during activity recreation but still won't let memoryLeaks happen.

Android implementation relies on next methods from public interface:

```
exports.init = function(credentials, paymentMethods, theme, success, error) {
    exec(success, error, 'SonectCordovaPlugin', 'init', [credentials, paymentMethods, theme]);
};

exports.presentTransaction = function(paymentReference, success, error) {
    exec(paymentReference, error, 'SonectCordovaPlugin', 'presentTransaction', [paymentReference]);
};
```

#### Theming

From `theme` structure in Android as of now we're only using light/dark switcher.