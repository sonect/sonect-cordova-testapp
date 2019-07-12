cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "ch.sonect.sdk.cordova.plugin.SonectCordovaPlugin",
      "file": "plugins/ch.sonect.sdk.cordova.plugin/www/SonectCordovaPlugin.js",
      "pluginId": "ch.sonect.sdk.cordova.plugin",
      "clobbers": [
        "sonect"
      ]
    }
  ];
  module.exports.metadata = {
    "ch.sonect.sdk.cordova.plugin": "0.0.1",
    "cordova-plugin-whitelist": "1.3.3"
  };
});