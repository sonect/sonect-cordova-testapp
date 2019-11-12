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

paymentUniqueIdentifier: null,    

    // Application Constructor
initialize: function() {
    document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    document.getElementById('openSonectButton').addEventListener('click', this.openSonect);
    document.getElementById('paySonectButton').addEventListener('click', this.paySonect);
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
        token: "NWMzMjMxMjAtNTAyNy0xMWU4LWFkM2YtN2JlN2MyNTFmYzYxOmI2NDQwN2I0MDlhYmJjNDI2OTc3MWNiZDFmN2MyOGRiZDQ5ODI3MGRlZmZmM2E2MDZmNWY0ZjJkMjdhNGUwN2E=",
        userId: "etLiIhOADD3F7EUZgdDackmmZbRji5",
        signature: "3stZup/AJQs3Y7EjHNEwOOVbCNc8A6cJ58YqlhDgt0Y="
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
            let balance = {
                uniqueIdentifier: uniqueIdentifier,
                value: "100.00",
                currency: "CHF"
            };
            balanceCallback(balance);
        },
        function(uniqueIdentifier, value, currency, paymentCallback) {
            //To process payment without leaving the SDK, follow this code path
            // let paymentReference = {
            //     uniqueIdentifier: uniqueIdentifier,
            //     paymentReference: "PAYMENT_REFERENCE"
            // };
            // paymentCallback(paymentReference);

            //Alternatively, hide the SDK, and call sonect.pay when you have obtained the payment reference
            sonect.hide(null, null);
            app.paymentUniqueIdentifier = uniqueIdentifier;
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
        }
    )
},

paySonect: function() {
    let paymentReference = {
        uniqueIdentifier: app.paymentUniqueIdentifier,
        paymentReference: "PAYMENT_REFERENCE"
    };

    sonect.presentTransaction(paymentReference, 
        function(msg) {
        },
        function(err) {
        }
    );
}
};

app.initialize();
