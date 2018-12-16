class RenameRejectsToRejectsOldInScans < ActiveRecord::Migration
  def self.up
    rename_column :scans, :rejects, :rejects_old
    
    Scan.all.each do |scan|
      @s = scan
      @s.reject_reason_1_quantity = @s.rejects_old unless @s.reject_reason_1_quantity
      @s.save
    end
  end

  def self.down
    rename_column :scans, :rejects_old, :rejects
  end
end
