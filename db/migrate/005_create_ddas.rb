class CreateDdas < ActiveRecord::Migration
  def self.up
    create_table :ddas do |t|
      t.integer :deal_id
      t.string :n
      t.string :e
      t.string :w
      t.string :s
      t.timestamps
    end
  end

  def self.down
    drop_table :ddas
  end
end
