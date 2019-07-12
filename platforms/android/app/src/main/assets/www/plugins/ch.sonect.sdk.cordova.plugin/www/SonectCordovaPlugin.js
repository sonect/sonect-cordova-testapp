cordova.define("ch.sonect.sdk.cordova.plugin.SonectCordovaPlugin", function(require, exports, module) {
cordova.define("ch.sonect.sdk.cordova.plugin.SonectCordovaPlugin", function(require, exports, module) {
    var exec = require('cordova/exec');
    
    var payInternal = null;
    var checkBalanceInternal = null;

    exports.present = function(sdkToken, userId, signature, checkBalance, pay, success, error) {
        this.payInternal = pay;
        this.checkBalanceInternal = checkBalance;
        exec(success, error, 'SonectCordovaPlugin', 'present', [sdkToken, userId, signature]);
    };

    exports.checkBalance = function(success, error) {
        this.checkBalanceInternal(function (balance) {
            exec(success, error, 'SonectCordovaPlugin', 'updateBalance', [balance])
        });
    }

    exports.pay = function(amount, success, error) {
        let amountObject = JSON.parse(amount)
        this.payInternal(amountObject.value, amountObject.currency, function (paymentReference){
            exec(success, error, 'SonectCordovaPlugin', 'processTransaction', [paymentReference])
        });
    };
});

});
