class AddArchiveToNcms < ActiveRecord::Migration
  def change
    add_column :ncms, :archive, :boolean, :default => false
  end
end
