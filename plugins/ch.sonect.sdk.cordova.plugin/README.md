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
        token: "YOUR_TOKEN_HERE",
        userId: "YOUR_USER_ID_HERE",
        signature: "YOUR_SIGNATURE_HERE"
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

    let paymentMethods = [
                          {
                          uniqueIdentifier: "IBAN_1",
                          name: "My Bank",
                          detailDescription: "Balance: 20CHF",
                          image: "Bank"
                          },
    ];

    sonect.present(credentials, paymentMethods, theme,
                   function(uniqueIdentifier, balanceCallback) {
                   //This method should check against the bank balance and return a balance.
                   let balance = {
                        uniqueIdentifier: uniqueIdentifier,
                        value: "20.00",
                        currency: "CHF"
                   };
                   balanceCallback(balance);
                   },
                   function(uniqueIdentifier, value, currency, paymentCallback) {
                   //This method should initiate bank payment and return a payment reference as a string.
                   let paymentReference = {
                        uniqueIdentifier: uniqueIdentifier,
                        paymentReference: "PAYMENT_REFERENCE"
                   };
                   paymentCallback(paymentReference);
                   },
                   function(msg) {
                   document
                   .getElementById('deviceready')
                   .querySelector('.received')
                   .innerHTML = msg;
                   },
                   function(err) {
                   document
                   .getElementById('deviceready')
                   .innerHTML = '<p class="event received">' + err + '</p>';
                   })
}
};
```
