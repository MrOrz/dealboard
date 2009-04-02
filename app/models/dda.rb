class Dda < ActiveRecord::Base
  belongs_to :deal
  
  def generate
    File.open("#{RAILS_ROOT}/lib/dd.tcl", "w") do |f| 
      f.print <<STOP
set diagram {
  {#{self.deal.ns} #{self.deal.nh} #{self.deal.nd} #{self.deal.nc}} 
  {#{self.deal.es} #{self.deal.eh} #{self.deal.ed} #{self.deal.ec}}
  {#{self.deal.ss} #{self.deal.sh} #{self.deal.sd} #{self.deal.sc}}
  {#{self.deal.ws} #{self.deal.wh} #{self.deal.wd} #{self.deal.wc}}
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
