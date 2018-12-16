class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.integer :subscribable_id
      t.string :subscribable_type

      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, [:subscribable_id, :subscribable_type]
  end
end
