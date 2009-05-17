$(document).ready(function(e){
  $('form').submit(function(){
    for(var i=0; i<4; ++i)
      update_card(i);
    for(var i=0; i<4; ++i){
      for(var j=0; j<4; ++j)
        if($(fields[i]).val().split(' ')[j].length == 0) return false;
      if(!card_st[i] || !pos_st[i]) return false;
    }
    return true;
  });
  for(var i=0; i<4; ++i)
    $(fields[i]).bind("keydown",{i: i}, function(e){
      update_card(e.data.i);
    });
});

var fields = ['#deal_n', '#deal_e', '#deal_s', '#deal_w'];
var mpos = ['#n', '#e', '#s', '#w'];
var card_st = [false, false, false, false];
var pos_st = [false, false, false, false];

function validcard(s) {
  if(/[AKQJT2-9]/.test(s)) {
    if(s == 'A') return 12;
    if(s == 'K') return 11;
    if(s == 'Q') return 10;
    if(s == 'J') return 9;
    if(s == 'T') return 8;
    return s-2;
  }
  return -1;
}

function update_hand(w) {
  var num = 0, hand = $(fields[w]).val().split(' ');
  for(var i=0; i<hand.length; ++i) {
    if(hand[i] != '-') num += hand[i].length;
  }
  if(num == 13) {
    pos_st[w] = true;
  } else {
    pos_st[w] = false;
    if(num > 13) $(mpos[w]).html("Too many cards!");
    else $(mpos[w]).html("Not enough!");
  }
}

function update_card(v) {
  card_st[v] = true;
  card = new Array(13);
  for(var i=0; i<13; ++i) card[i] = false;
  $(mpos[v]).html("");
  for(var j=0; j<$(fields[v]).val().split(' ').length; ++j) {
    var nowj = $(fields[v]).val().split(' ')[j];
    if(nowj != '-') {
      for(var i=0; i<nowj.length; ++i) {
        var s = validcard(nowj[i]);
        if(s >= 0) {
          if(card[s]) {
            $(mpos[v]).html("At least one card is duplicated.");
            card_st[v] = false;
          } else {
            card[s] = true;
          }
        } else {
          $(mpos[v]).html("Not a card!");
          card_st[v] = false;
        }
      }
      if(card_st[v]) $(mpos[v]).html("");
    }
  }
  update_hand(v);
}

