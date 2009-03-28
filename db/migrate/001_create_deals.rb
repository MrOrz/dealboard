class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.integer :user_id
      t.string :title
      t.string :ns
      t.string :nh
      t.string :nd
      t.string :nc
      t.string :es
      t.string :eh
      t.string :ed
      t.string :ec
      t.string :ss
      t.string :sh
      t.string :sd
      t.string :sc
      t.string :ws
      t.string :wh
      t.string :wd
      t.string :wc
      t.string :dealer
      t.string :vul
      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
