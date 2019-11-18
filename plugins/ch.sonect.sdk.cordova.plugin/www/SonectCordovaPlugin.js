var exec = require('cordova/exec');

var payInternal = null;
var checkBalanceInternal = null;

exports.init = function(credentials, paymentMethods, theme, success, error) {
    exec(success, error, 'SonectCordovaPlugin', 'init', [credentials, paymentMethods, theme]);
};

// Android impl will ignore checkBalance and pay functions in params.
exports.present = function(checkBalance, pay, success, error) {
    this.payInternal = pay;
    this.checkBalanceInternal = checkBalance;
    exec(success, error, 'SonectCordovaPlugin', 'present', []);
};

// Android impl will ignore checkBalance method.
// It uses paymentMethod provided in #init
exports.checkBalance = function(uniqueIdentifier, success, error) {
    this.checkBalanceInternal(uniqueIdentifier, function (balance) {
        exec(success, error, 'SonectCordovaPlugin', 'updateBalance', [balance])
    });
};

// Android impl will ignore pay method.
// It will just closes SDK activity with result and request codes + data in bundle.
exports.pay = function(amount, success, error) {
    let amountObject = JSON.parse(amount)
    this.payInternal(amountObject.uniqueIdentifier, amountObject.value, amountObject.currency, function (paymentReference){
        exec(success, error, 'SonectCordovaPlugin', 'processTransaction', [paymentReference])
    });
};

// Android impl will ignore hide method.
// It will just closes SDK activity by itself 
// with result and request codes + data in bundle.
exports.hide = function(msg, success, error) {
    exec(success, error, 'SonectCordovaPlugin', 'hideSdk', [msg]);
};

exports.presentTransaction = function(paymentReference, success, error) {
    exec(paymentReference, error, 'SonectCordovaPlugin', 'presentTransaction', [paymentReference]);
};
