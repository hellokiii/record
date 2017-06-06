class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id, default: 1
      t.string :name
      t.string :game
      t.string :single
      t.string :double
      t.string :triple
      t.string :homerun
      t.string :steal
      t.string :pb
      t.string :strikeout
      t.string :baseonballs
      t.string :hbp
      t.boolean :selected, default: false
      t.integer :batting_order, default: 0
      t.timestamps null: false
    end
  end
end
