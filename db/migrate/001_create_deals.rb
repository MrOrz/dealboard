class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.integer :user_id
      t.string :title
      t.string :s
      t.string :n
      t.string :w
      t.string :e
      t.string :krp
      t.string :dealer
      t.string :vul
      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
