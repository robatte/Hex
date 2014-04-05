// Generated by CoffeeScript 1.7.1
Crafty.scene('Level', function(game) {
  Crafty.viewport.mouselook(true);
  return Crafty.e('Map').map(game);
});

Crafty.scene('Menu', function(game) {
  Crafty.e('2D, DOM, Text').attr({
    x: 0,
    y: game.height / 2 - 24,
    w: game.width
  }).text("Menue").textFont({
    'weight': 'bold',
    'size': '50px'
  }).css({
    'text-align': 'center',
    'color': '#333'
  });
  return this.restart_level = this.bind('KeyDown', function() {
    return Crafty.scene('Level', game);
  });
}, function() {
  return this.unbind('KeyDown', this.restart_level);
});
