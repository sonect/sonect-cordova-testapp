/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
initialize: function() {
    document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    document.getElementById('openSonectButton').addEventListener('click', this.openSonect);
},

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
onDeviceReady: function() {
    this.receivedEvent('deviceready');
},

    // Update DOM on a Received Event
receivedEvent: function(id) {
    var parentElement = document.getElementById(id);
    var listeningElement = parentElement.querySelector('.listening');
    var receivedElement = parentElement.querySelector('.received');

    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');

    console.log('Received Event: ' + id);
},

openSonect: function() {
    let credentials = {
        token: "NDhkOGNiNTAtYjliNC0xMWU5LWJlNGMtNWRiNTMyOGNhZmE0OmY4ZWFhYzNlMGQyNjE5MjhiZGI5ZjQxNTk3NGVkMTU4MjA0YjQ5NTVhNzdjMDZiZTA1YTBjZWI3Nzk2NzExYzg=",
        userId: "user1",
        signature: "sUFLKPul8oTJZjBH/XvVhEv43zHs/F8fUbKuVEB0SFo="
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

app.initialize();
