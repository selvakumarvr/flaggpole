class AddIndexOnHeadline < ActiveRecord::Migration
	def change
		add_index :infos, :headline, :length => 100
	end
end
