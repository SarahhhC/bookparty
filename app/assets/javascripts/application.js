// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-datepicker
//= require jquery-clockpicker
//= require countdown
//= require chart
//= require websocket_rails

var task = {
      name: 'Start taking advantage of WebSockets',
      completed: false
}

var dispatcher = new WebSocketRails('203.252.195.148:80/websocket');

dispatcher.bind('tasks.create_success', function(task) {
console.log('successfully created ');
});
dispatcher.trigger('tasks.create', task);


