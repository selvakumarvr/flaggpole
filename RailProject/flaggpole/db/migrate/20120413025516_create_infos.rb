class CreateInfos < ActiveRecord::Migration
  def self.up
    create_table :infos do |t|
      t.references :alert
      t.string :category, :null => false
      t.text :language
      t.text :event, :null => false
      t.string :response_type
      t.string :urgency, :null => false
      t.string :severity, :null => false
      t.string :certainty, :null => false
      t.text :audience
      t.datetime :effective
      t.datetime :onset
      t.datetime :expires
      t.text :senderName
      t.text :headline
      t.text :description
      t.text :instruction
      t.text :web
      t.text :contact

      t.timestamps
    end
    add_index :infos, :alert_id
  end

  def self.down
    drop_table :infos
  end
end
