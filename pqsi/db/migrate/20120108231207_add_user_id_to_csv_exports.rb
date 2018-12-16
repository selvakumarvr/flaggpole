class AddUserIdToCsvExports < ActiveRecord::Migration
  def change
    add_column :csv_exports, :user_id, :integer
  end
end
