class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_one :dda, :dependent => :destroy
  acts_as_taggable

  validates_presence_of :title

  def sort
    self.n = self.n.upcase.split.each {|i| i = sort_card(i) }.join(" ")
    self.e = self.e.upcase.split.each {|i| i = sort_card(i) }.join(" ")
    self.s = self.s.upcase.split.each {|i| i = sort_card(i) }.join(" ")
    self.w = self.w.upcase.split.each {|i| i = sort_card(i) }.join(" ")
    c = Array.new
    [self.n, self.w, self.e, self.s].each {|i| c << calc_krp(i).to_s }
    self.krp = c.join(" ")
    self.save
  end

private
  def to_url
    self.title.gsub(/ /,'-')
  end

  def sort_card(s)
    s.sub(/A/,"e").sub(/K/,"d").sub(/Q/,"c").sub(/J/,"b").sub(/T/, "a").split("").sort.reverse.join.sub(/e/,"A").sub(/d/,"K").sub(/c/,"Q").sub(/b/,"J").sub(/a/,"T")
  end

  def calc_krp(s)
    hand = s.split
    distribution = 0
    result = 0
    #for each suit
    hand.each do |suit|
      #Distribution
      case suit
        when "-"
          distribution += 3
          next
        when /\A.\Z/ then distribution += 2
        when /\A..\Z/ then distribution += 1
      end
      #High cards
      #A
      result += 3 if suit =~ /A/
      #K
      result += (suit.length == 1 ? 0.5 : 2) if suit =~ /K/
      #Q
      result += case suit
                      when /(A|K)Q\Z/ then 0.5 #AQ or KQ doubleton
                      when /\AQ.\Z/ then 0.25 #Qx
                      when /\AQ\Z/ then 0 #stiff Q
                      when /\AQ../ then 0.75
                      when /Q/ then 1
                      else 0
                    end
      #J
      result += case suit
                      when /\A..J/ then 0.5 #AKJ or AQJ or KQJ
                      when /\A.J/ then 0.25 #AJ or KJ or QJ
                      else 0
                    end
      #T
      result += 0.25 if suit =~ /\A..T|\A.T9/
      #Suit quality
      suitQuality = 0
      suitQuality += 4 if suit =~ /A/
      suitQuality += 3 if suit =~ /K/
      suitQuality += 2 if suit =~ /Q/
      suitQuality += 1 if suit =~ /J/
      #length modification
      if suit.length <= 6
        suitQuality += if suit =~ /..T|JT/ then 1
                            elsif suit =~ /T/ then 0.5
                            else 0
                            end
        suitQuality += 0.5 if suit =~ /T9|98|..9/
      elsif suit.length == 7 then suitQuality += 1 if suit !~ /QJ/
      elsif suit.length == 8
        suitQuality += if suit !~ /Q/ then 2
                            elsif suit !~ /J/ then 1
                            else 0
                            end
      else
        suitQuality += 2 if suit !~ /Q/
        suitQuality += 1 if suit !~ /J/
      end #end of length modification
      suitQuality *= ( suit.length / 10.0 )
      result += suitQuality
    end #end of hand.each
    #4333
    if distribution == 0 then distribution -= 0.5
    else distribution -= 1
    end
    result += distribution
  end #end of method krp
end

