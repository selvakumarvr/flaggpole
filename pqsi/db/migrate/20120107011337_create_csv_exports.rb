class CreateCsvExports < ActiveRecord::Migration
  def change
    create_table :csv_exports do |t|
      t.string :file
      t.integer :generated_by_id

      t.timestamps
    end
  end
end
