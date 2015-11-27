window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console){
    console.log( Array.prototype.slice.call(arguments) );
  }
};

$(function () {
  var url = window.location.search.match(/url=([^&]+)/);
  if (url && url.length > 1) {
    url = decodeURIComponent(url[1]);
  } else {
    url = location.protocol + "//" + location.host + "/swagger.json";
  }
  window.swaggerUi = new SwaggerUi({
    url: url,
    dom_id: "swagger-ui-container",
    supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
    onComplete: function(swaggerApi, swaggerUi){
      $('pre code').each(function(i, e) {
        hljs.highlightBlock(e)
      });
    },
    onFailure: function(data) {
      log("Unable to Load SwaggerUI");
    },
    docExpansion: "none",
    apisSorter : "alpha"
  });

  function addApiKeyAuthorization() {
    var $apiSelectorForm = $('#api_selector');
    var authenticationKey = $apiSelectorForm.data('authenticationKey');
    var authenticationType = $apiSelectorForm.data('authenticationType');

    var key = $('#input_apiKey')[0].value;

    if(key && key.trim() != '') {
      swaggerUi.api.clientAuthorizations.add(
        'key',
        new SwaggerClient.ApiKeyAuthorization(authenticationKey, key, authenticationType)
      );
    }
  }

  var $apiKeyInput = $('#input_apiKey');

  $apiKeyInput.change(function() {
    addApiKeyAuthorization();
  });

  var $apiSelectorForm = $('api_selector');
  var apiKey = $apiSelectorForm.data('authenticationValue');
  $apiKeyInput.val(apiKey);
  addApiKeyAuthorization();

  window.swaggerUi.load();
});