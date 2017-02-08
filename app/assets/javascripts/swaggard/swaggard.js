window.log = function(){
  if ('console' in window) {
    console.log.apply(console, arguments);
  }
};

$(function () {
  var url = window.location.search.match(/url=([^&]+)/);
  if (url && url.length > 1) {
    url = decodeURIComponent(url[1]);
  } else {
    url = location.protocol + "//" + location.host + $('body').data('docPath')
  }

  hljs.configure({
    highlightSizeThreshold: 5000
  });

  if(window.SwaggerTranslator) {
    window.SwaggerTranslator.translate();
  }

  window.swaggerUi = new SwaggerUi({
    url: url,
    dom_id: "swagger-ui-container",
    supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
    onComplete: function(swaggerApi, swaggerUi){
      if(window.SwaggerTranslator) {
        window.SwaggerTranslator.translate();
      }

      // set default content type
      $('select[name="responseContentType"]').val(window.default_content_type);
      $('select[name="parameterContentType"]').val(window.default_content_type);

      $('.additional_parameter').each(function() {
        updateParameter(this);
      });
    },
    onFailure: function(data) {
      log("Unable to Load SwaggerUI");
    },
    docExpansion: 'none',
    jsonEditor: true,
    defaultModelRendering: 'schema',
    showRequestHeaders: true,
    apisSorter : 'alpha'
  });

  function updateParameter(input) {
    var $input = $(input);

    var parameterKey = $input.data('parameterKey');
    var parameterType = $input.data('parameterType');
    var value = $input.val();

    if(value && value.trim() != '') {
      swaggerUi.api.clientAuthorizations.add(
        parameterKey,
        new SwaggerClient.ApiKeyAuthorization(parameterKey, value, parameterType)
      );
    } else {
      swaggerUi.api.clientAuthorizations.remove(parameterKey);
    }
  }

  $('.additional_parameter').change(function() {
    updateParameter(this);
  });

  window.swaggerUi.load();
});
