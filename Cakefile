fs       = require 'fs'
path     = require 'path'       
stylus   = require 'stylus'
Snockets = require 'snockets'
snockets = new Snockets()     

buildCSS = (callback) ->
  css_str = fs.readFileSync('css/index.styl', 'utf8')         
  stylus.render css_str, filename: 'index.styl', (err, css) ->
    fs.writeFile 'build/css/formsSuck.css', css

build = (callback) ->
  js = snockets.getConcatenation 'lib/formsSuck.coffee', async: false   
  fs.writeFile 'build/js/formsSuck.js', js     
  
buildJquery = (callback) -> 
  js     = snockets.getConcatenation 'lib/formsSuck.coffee', async: false  
  jquery = fs.readFileSync('lib/vendor/jquery-1.7.2.min.js', 'utf8') 
  js     = jquery + js          
  fs.writeFile 'build/js/formsSuckwithjquery.js', js        
 
buildDemo = (callback) ->   
  js     = snockets.getConcatenation 'lib/formsSuck.coffee', async: false
  jquery = fs.readFileSync('lib/vendor/jquery-1.7.2.min.js', 'utf8') 
  js = jquery + js          
  fs.writeFile 'demo/demo.js', js   
  css_str = fs.readFileSync('css/index.styl', 'utf8')         
  stylus.render css_str, filename: 'index.styl', (err, css) ->
    fs.writeFile 'demo/demo.css', css  

task 'build:all', 'Builds everything including demo', -> 
 buildCSS()
 buildJquery() 
 buildDemo()

task 'build', 'Builds to /build', ->
  buildCSS()
  build()
  
task 'build:withjquery', 'Builds with jQuery to /build', ->   
  buildCSS()   
  buildJquery() 
  
task 'build:demo', 'Builds the demo files',  ->
  buildDemo()