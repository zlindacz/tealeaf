$(document).ready(function() {
  player_hits();
  player_stands();
  dealer_hits();
});

function player_hits() {
  $(document).on('click', '#player_hit button', function() {
    $.ajax({
      type: 'POST',
      url: '/game/player/hit'
    }).done(function(msg) {
      $('#game').replaceWith(msg);
    });
    return false;
  });
}

function player_stands() {
  $(document).on('click', '#player_stand button', function() {
    $.ajax({
      type: 'POST',
      url: '/game/player/stand'
    }).done(function(msg) {
      $('#game').replaceWith(msg);
    });
    return false;
  });
}

function dealer_hits() {
  $(document).on('click', '#dealer_hit input', function() {
    $.ajax({
      type: 'POST',
      url: '/game/dealer_turn'
    }).done(function(msg) {
      $('#game').replaceWith(msg);
    });
    return false;
  });
}
