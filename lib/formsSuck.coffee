#= require './vendor/jquery.ujs.js'
#= require './vendor/jquery.validator.js'
#= require './vendor/jquery.labelify.js'
#= require './vendor/jquery.password123.js'   

(($) ->
  $.formsSuck = (el, options) ->    
    @$form = $(el)   
    @$form.data "formsSuck", @

    @init = =>
      @options = $.extend {}, $.formsSuck.defaultOptions, options
      @
    @init()    
        
    @$form.children('input:not(:password)').labelify(text: "label")
    @$form.children('input:password').password123()    
    @validator = @$form.validate()    
    
    $form.fn.extend
      showError: (message) ->
        error_html = $.parseTMPL('form_error', message: message)
        error_html.append_to($form).fadeIn(300)
        
    $form.children('fieldset').each (step) ->
      fieldset_html = $.parseTMPL('step', fields: $(step).children('input, textarea').html, 
        title: $(step).children('.title').html, desc: $(step).children('.desc').html)
      step.remove
      fieldset_html.append_to($form)
    
    @$form.live "ajax:failure", (event, xhr, status) ->
      response = $.parseJSON(xhr.responseText)
      if $.isPlainObject(response)   
        if response.errors
          @validator.showErrors(response.errors)   
        else if response.message 
          @$form.showError response.message     
        else if response.status is 'fail'
          @validator.showErrors(response.data)
        else
          @$form.showError @options.default_error

    @$form.live "ajax:success", (event, xhr, status) ->
      response = $.parseJSON(xhr.responseText)
      location.reload if @options.redirect_url == location   
      location(@options.redirect_url)    
      
    parseTMPL: (template, data) ->   
      parsed = ''
      if($("[name=#{template}]")) 
        parsed = $("[name=#{template}]").tmpl(data)        
      else if $.tmpl('views/#{template}') 
        parsed = $.tmpl('views/#{template}')(data)
      else
        $.get "settings.template_path/#{template}", (response) ->    
          parsed = $.tmpl response, data 
      return parsed           

  $.formsSuck.defaultOptions = 
    autocomplete: 'off'
    lang: 'en'      
    redirect_url: location   
    templates_path: 'templates'    
    default_error: 'Form submission failed' 

  $.fn.formsSuck = (options) ->
    $.each @, (i, el) ->
      $el = $ el

      unless $el.data 'formsSuck'
        $el.data 'formsSuck', new $.formsSuck el, options
)(jQuery)