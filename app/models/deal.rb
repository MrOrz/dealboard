class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_one :dda, :dependent => :destroy
  acts_as_taggable

  validates_presence_of :title

  def sort
    k = Array.new
    self.n.upcase.split.each {|i| k << sort_card(i) }
    self.n = k.join(" ")
    k.clear
    self.e.upcase.split.each {|i| k << sort_card(i) }
    self.e = k.join(" ")
    k.clear
    self.s.upcase.split.each {|i| k << sort_card(i) }
    self.s = k.join(" ")
    k.clear
    self.w.upcase.split.each {|i| k << sort_card(i) }
    self.w = k.join(" ")
    self.save
  end

private
  def to_url
    self.title.gsub(/ /,'-')
  end

  def sort_card(s)
    s.sub(/A/,"e").sub(/K/,"d").sub(/Q/,"c").sub(/J/,"b").sub(/T/, "a").split("").sort.reverse.join.sub(/e/,"A").sub(/d/,"K").sub(/c/,"Q").sub(/b/,"J").sub(/a/,"T")
  end
end

