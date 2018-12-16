class CreatePdfExports < ActiveRecord::Migration
  def change
    create_table :pdf_exports do |t|
      t.string :file
      t.integer :user_id
      t.integer :ncm_id
      t.string :filter_hash

      t.timestamps
    end
  end
end
