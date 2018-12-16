class AddCreatedAtDateToZipMessages < ActiveRecord::Migration
  def self.up
    say_with_time "adding created_at_date column" do
      add_column :zip_messages, :created_at_date, :date, :after => :content
    end
    
    say_with_time "adding index on created_at_date" do
      add_index :zip_messages, :created_at_date
    end
    
    say_with_time "setting created_at_date" do
      ZipMessage.reset_column_information
      ZipMessage.update_all("created_at_date = created_at")
    end
  end

  def self.down
    remove_index :zip_messages, :created_at_date
    remove_column :zip_messages, :created_at_date
  end
end
