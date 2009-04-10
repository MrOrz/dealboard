$(document).ready(function(e){
  $('#bid_seq').keydown(check_seq);
});

function valid_bid(s) {
  if(/[1-7][CDHSN]/.test(s)) return 1;
  if(/[1-7][CDHSN]/.test(s)) return 1;
  if(/P|X|XX/.test(s)) return 2;
  return -1;
}

function suff(s, t) {
  if(s[0]<t[0]) return true;
  if(s[0]>t[0]) return false;
  s.replace(/C/,"1").replace(/D/,"2").replace(/H/,"3").replace(/S/,"4").replace(/N/,"5");
  t.replace(/C/,"1").replace(/D/,"2").replace(/H/,"3").replace(/S/,"4").replace(/N/,"5");
  if(s[1]<t[1]) return true;
  return false;
}

function check_seq() {
  $('#msg').html('');
  var doubled = false, redoubled = false, last = "", pass = 0, lastpos = 0;
  var t = $('#bid_seq').val().split("-");
  for(var i = 0; i<t.length; ++i) {
    var nt = valid_bid(t[i]);
    if(nt < 0) { $('#msg').html('Not a valid bid.'); return; }
    if(nt == 1) {
      pass = 0;
      double = false;
      redouble = false;
      lastpos = i % 4;
      if(!(last == ""))
        if(!suff(last, t[i])) { $('#msg').html('Insufficient bid.'); return; }
      last = t[i];
    } else {
      if(t[i] == "P") {
        if((pass == 3 && last != "")||(pass == 4)) { $('#msg').html('Too many passes.'); return; }
        pass++;
      }
      if(t[i] == "X") {
        if(doubled||(i%2 == lastpos%2)) { $('#msg').html('Invalid double.'); return; }
        doubled = true;
        pass = 0;
      }
      if(t[i] == "XX") {
        if(!doubled || redoubled || (i%2 != lastpos%2)) { $('#msg').html('Invalid redouble.'); return; }
        redouble = true;
        pass = 0;
      }
    }
  }
}

