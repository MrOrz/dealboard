class Dda < ActiveRecord::Base
  belongs_to :deal
  
  def generate
    File.open("#{RAILS_ROOT}/lib/dd.tcl", "w") do |f| 
      f.print <<STOP
set diagram {
  {#{self.deal.n}} 
  {#{self.deal.e}}
  {#{self.deal.s}}
  {#{self.deal.w}}
}
foreach hand {north east south west} {
  foreach denom {clubs diamonds hearts spades notrump} {
    set trick [dds -diagram $diagram $hand $denom]
    puts -nonewline "$trick "
  }
  puts ""
}
STOP
    end
    system "cd #{RAILS_ROOT}/lib/deal; ./deal -i ../dd.tcl 0 > ../result"
    a = IO.readlines("#{RAILS_ROOT}/lib/result")
    self.n = a[0].chomp
    self.e = a[1].chomp
    self.s = a[2].chomp
    self.w = a[3].chomp
    self.save
  end
end
