class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :name
    end
    Source.create(:name => 'Outside.in')
    Source.create(:name => 'EveryBlock')
  end

  def self.down
    drop_table :sources
  end
end
