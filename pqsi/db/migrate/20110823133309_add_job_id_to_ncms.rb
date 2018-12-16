class AddJobIdToNcms < ActiveRecord::Migration
  def self.up
    add_column :ncms, :job_id, :integer
  end

  def self.down
    remove_column :ncms, :job_id
  end
end
