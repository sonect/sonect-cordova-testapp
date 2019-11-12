cordova.define("ch.sonect.sdk.cordova.plugin.SonectCordovaPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

var payInternal = null;
var checkBalanceInternal = null;

exports.present = function(credentials, paymentMethods, theme, checkBalance, pay, success, error) {
    this.payInternal = pay;
    this.checkBalanceInternal = checkBalance;
    exec(success, error, 'SonectCordovaPlugin', 'present', [credentials, paymentMethods, theme]);
};

exports.checkBalance = function(uniqueIdentifier, success, error) {
    this.checkBalanceInternal(uniqueIdentifier, function (balance) {
        exec(success, error, 'SonectCordovaPlugin', 'updateBalance', [balance])
    });
};

exports.pay = function(amount, success, error) {
    let amountObject = JSON.parse(amount)
    this.payInternal(amountObject.uniqueIdentifier, amountObject.value, amountObject.currency, function (paymentReference){
        exec(success, error, 'SonectCordovaPlugin', 'processTransaction', [paymentReference])
    });
};

exports.hide = function(msg, success, error) {
    exec(success, error, 'SonectCordovaPlugin', 'hideSdk', [msg]);
};

exports.presentTransaction = function(paymentReference, success, error) {
    exec(paymentReference, error, 'SonectCordovaPlugin', 'presentTransaction', [paymentReference]);
};

});
