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
    let token = "NWMzMjMxMjAtNTAyNy0xMWU4LWFkM2YtN2JlN2MyNTFmYzYxOmI2NDQwN2I0MDlhYmJjNDI2OTc3MWNiZDFmN2MyOGRiZDQ5ODI3MGRlZmZmM2E2MDZmNWY0ZjJkMjdhNGUwN2E="
    let userId = "OepMZR0Ey9bzec3aNeIAjvzWdmy08C"
    let signature = "jte2bhHnURx0Pbwgf3I05v+RzjPZsC5tLCvq5FJFcbU="

    sonect.present(token, userId, signature,
                   function(balanceCallback) {
                   //This method should check against the bank balance and return a balance.
                   let balance = {
                        value: "20.00",
                        currency: "CHF"
                   };
                   balanceCallback(balance);
                   },
                   function(value, currency, paymentCallback) {
                   //This method should initiate bank payment and return a payment reference as a string.
                   let paymentReference = "PAYMENT_REFERENCE";
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
