class AddUniqueIndexOnCrawls < ActiveRecord::Migration
  def self.up
    crawls = Crawl.all(:group => 'source_id,zip')
    execute "truncate crawls"
    add_index :crawls, [:source_id, :zip], :unique => true, :name => 'source_zip_index'
    crawls.each { |c| Crawl.create(:source_id => c.source_id, :zip => c.zip) }
  end

  def self.down
    remove_index :crawls, :source_zip_index
  end
end
