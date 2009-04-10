class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_one :dda, :dependent => :destroy
  acts_as_taggable_on :tags
  
  validates_presence_of :title
  
  def sort
    self.ns = self.sort_card(self.ns)
    self.nh = self.sort_card(self.nh)
    self.nd = self.sort_card(self.nd)
    self.nc = self.sort_card(self.nc)
    self.es = self.sort_card(self.es)
    self.eh = self.sort_card(self.eh)
    self.ed = self.sort_card(self.ed)
    self.ec = self.sort_card(self.ec)
    self.ss = self.sort_card(self.ss)
    self.sh = self.sort_card(self.sh)
    self.sd = self.sort_card(self.sd)
    self.sc = self.sort_card(self.sc)
    self.ws = self.sort_card(self.ws)
    self.wh = self.sort_card(self.wh)
    self.wd = self.sort_card(self.wd)
    self.wc = self.sort_card(self.wc)
    self.save
  end
  
  def to_url
    self.title.gsub(/ /,'-')
  end
  
  def sort_card(s)
    s.sub(/A/,"e").sub(/K/,"d").sub(/Q/,"c").sub(/J/,"b").sub(/T/, "a").split("").sort.reverse.join.sub(/e/,"A").sub(/d/,"K").sub(/c/,"Q").sub(/b/,"J").sub(/a/,"T")
  end
end
