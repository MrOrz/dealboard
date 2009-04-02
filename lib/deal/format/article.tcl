set deal::unicode 0

proc notrump.Level {tricks1 tricks2} {
   if {$tricks2==13} { return 4 }
   if {$tricks2==12} { return 3}
   if {$tricks1<9 && $tricks2>=9} { return 2 }
   if {$tricks2>6} { return 1 }
   return 0
}

proc suit.Level {tricks1 tricks2} {
   if {$tricks2==13} { return 4 }
   if {$tricks2==12} { return 3 }
   if {$tricks2==11 || $tricks2==10} { return 2 }
   if {$tricks2>6} { return 1 }
   return 0
}

proc write_hand {name hand} {
   set result "<$name";
   foreach suit $hand label {sp he di cl} {
      set result "$result $label='$suit'"
   }
   set result "$result/>"
   puts $result
}

proc xml_write_deal {} {
   foreach handname {north west east south} {
      set hand [$handname]
      write_hand $handname $hand
   }
}

proc write_deal {} {
   global items
   puts "<diagram>"
   puts "<!--"
   foreach item $items { puts $item }
   formatter::write_deal
   puts "-->"
   xml_write_deal
   puts "</diagram>"
   set items [list]
}

set formatter::voidsymbol "-"

set items [list]
