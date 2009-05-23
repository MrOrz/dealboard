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

