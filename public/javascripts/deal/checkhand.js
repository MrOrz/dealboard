$(document).ready(function(e){
  $('form').submit(function(){
    for(var i=0; i<4; ++i)
      update_card(i, i);
    for(var i=0; i<4; ++i){
      for(var j=0; j<4; ++j) 
        if($(fields[i][j]).val().length == 0) return false;
      if(!card_st[i] || !pos_st[i]) return false;
    }
    return true;
  });
  for(var i=0; i<4; ++i)
    for(var j=0; j<4; ++j)
      $(fields[i][j]).bind("keydown",{i: i, j: j}, function(e){
        update_card(e.data.i,e.data.j); 
      });
});

var fields = [['#deal_ns', '#deal_es', '#deal_ss', '#deal_ws'],
['#deal_nh', '#deal_eh', '#deal_sh', '#deal_wh'],
['#deal_nd', '#deal_ed', '#deal_sd', '#deal_wd'],
['#deal_nc', '#deal_ec', '#deal_sc', '#deal_wc']];
var msgf = [['#ns', '#es', '#ss', '#ws'],
['#nh', '#eh', '#sh', '#wh'],
['#nd', '#ed', '#sd', '#wd'],
['#nc', '#ec', '#sc', '#wc']];
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
  var num = 0;
  $(mpos[w]).html("");
  for(var i=0; i<4; ++i) {
    if($(fields[i][w]).val() != '-') num += $(fields[i][w]).val().length;
  }
  if(num == 13) {
    pos_st[w] = true;
  } else {
    pos_st[w] = false;
    if(num > 13) $(mpos[w]).html("Too many cards!");
    else $(mpos[w]).html("Not enough!");
  }
}

function update_card(v, w) {
  card_st[v] = true;
  card = new Array(13);
  for(var i=0; i<13; ++i) card[i] = false;
  for(var j=0; j<4; ++j) {
    $(msgf[v][j]).html("");
    if($(fields[v][j]).val() != '-') {
      for(var i=0; i<$(fields[v][j]).val().length; ++i) {
        var s = validcard($(fields[v][j]).val()[i]);
        if(s >= 0) {
          if(card[s]) {
            $(msgf[v][j]).html("At least one card is duplicated.");
            card_st[v] = false;
          } else {
            card[s] = true;
          }        
        } else {
          $(msgf[v][j]).html("Not a card!");
          card_st[v] = false;
        }
      }
      if(card_st[v]) $(msgf[v][j]).html("");
    }
  }
  update_hand(w);
}
