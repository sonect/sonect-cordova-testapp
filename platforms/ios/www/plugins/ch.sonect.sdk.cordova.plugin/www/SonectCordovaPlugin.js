cordova.define("ch.sonect.sdk.cordova.plugin.SonectCordovaPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

var payInternal = null;
var checkBalanceInternal = null;

exports.present = function(sdkToken, userId, signature, paymentMethods, checkBalance, pay, success, error) {
    console.log("PRESENTING SONECT");

    this.payInternal = pay;
    this.checkBalanceInternal = checkBalance;
    exec(success, error, 'SonectCordovaPlugin', 'present', [sdkToken, userId, signature, paymentMethods]);
};

exports.checkBalance = function(uniqueIdentifier, success, error) {
    console.log("CHECK BALANCE SONECT");

    console.log(uniqueIdentifier);
    this.checkBalanceInternal(uniqueIdentifier, function (balance) {
        exec(success, error, 'SonectCordovaPlugin', 'updateBalance', [balance])
    });
}

exports.pay = function(amount, success, error) {
    let amountObject = JSON.parse(amount)
    this.payInternal(amountObject.uniqueIdentifier, amountObject.value, amountObject.currency, function (paymentReference){
        exec(success, error, 'SonectCordovaPlugin', 'processTransaction', [paymentReference])
    });
};

});
