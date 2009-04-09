class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_one :dda, :dependent => :destroy
  acts_as_taggable_on :tags
  
  validates_presence_of :title
  
  def before_save
    dda = Dda.create(:deal => @deal)
    MiddleMan.worker(:ddaw_worker).enq_execdda(:arg => dda, :job_key => dda.id.to_s)
    [self.ns, self.nh, self.nd, self.nc, self.ws, self.wh, self.wd, self.wc, self.ss, self.sh, self.sd, self.sc, self.es, self.eh, self.ed, self.ec].each {|s| s = sort_card(s)}
  end
  
  def to_url
    self.title.gsub(/ /,'-')
  end
  
  def sort_card(s)
    s.sub(/A/,"e").sub(/K/,"d").sub(/Q/,"c").sub(/J/,"b").sub(/T/, "a").split("").sort.reverse.join.sub(/e/,"A").sub(/d/,"K").sub(/c/,"Q").sub(/b/,"J").sub(/a/,"T")
  end
end
