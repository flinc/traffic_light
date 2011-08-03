$(document).ready(function(){

  $('#update').ajaxSend(function() {
    $(this).text('Updating...');
  }).ajaxSuccess(function() {
    $(this).text('Updated!');
  }).ajaxError(function() {
    $(this).text('Error! :(');
  });

  var setMultilightMode = function(enabled) {
    optionButtons.each(function(){
      var el = $(this);
      if(el.data('multiLightMode') == enabled) {
        el.addClass('active');
      } else {
        el.removeClass('active');
      }
    });
  };

  var currentState = function() {
    var state = {};
    $('#traffic_light a').each(function(){
      var el = $(this);
      state[el.data('lightColor')] = el.data('lightEnabled') ? 1 : 0;
    });
    return state;
  };

  var currentStateFromRemote = function() {
    $.get('/lights', function(data) {
      updateCurrentState(JSON.parse(data));
    });
  };

  var updateCurrentState = function(data) {
    if(typeof data['multi_light_mode'] != 'undefined') {
      setMultilightMode(data['multi_light_mode']);
    }
    $('#traffic_light a').each(function(){
      var el = $(this), color = el.data('lightColor');
      if(data[color] != undefined) {
        el.data('lightEnabled', data[color]);
        el.data('lightEnabled') == 1 ? el.addClass('on') : el.removeClass('on');
      }
    });
  };

  $('#traffic_light a').each(function(){
    var el = $(this);
    el.data('lightColor', el.attr('class'));
    el.data('lightEnabled', false);

    el.click(function() {
      if(!$('#options a.button.active').data('multiLightMode')) {
        $('#traffic_light a').each(function(){
          if(el != $(this)) {
            $(this).data('lightEnabled', false);
          }
        });
      }

      el.data('lightEnabled', !el.data('lightEnabled'));
      $.post('/lights',  currentState(), function(data) {
        updateCurrentState(JSON.parse(data));
      });
    });
  });

  var optionButtons = $('#options a.button');
  optionButtons.each(function(){

    var el = $(this);

    if(el.attr('id') == 'singleLight') {
      el.data('multiLightMode', false);
    }

    if(el.attr('id') == 'multiLight') {
      el.data('multiLightMode', true);
    }

    el.click(function(){
      setMultilightMode($(this).data('multiLightMode'));
      $.post('/lightmode',  { multi_light_mode: $('#options a.button.active').data('multiLightMode') }, function(data) {
        updateCurrentState(JSON.parse(data));
      });
    });
  });

  setInterval(currentStateFromRemote, 5000);
  currentStateFromRemote();
});