class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.string :identifier, :null => false
      t.text :sender, :null => false
      t.datetime :sent, :null => false
      t.string :status, :null => false
      t.string :msgType, :null => false
      t.string :source
      t.string :scope, :null => false
      t.text :restriction
      t.text :addresses
      t.text :note
      t.text :references
      t.text :incidents

      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
