task :find_duplicate_scans => :environment do
  @scans_scope = Scan.scoped
  @total_count = @scans_scope.count
  @has_duplicate_data = []

  total_loops = (@total_count / 1000) + 1

  total_loops.times do |n|
    @scans = @scans_scope.offset(n * 1000).limit(1000)

    @scans.each do |scan|
      if NcmDataFile.new.scan_exists?(scan.row_id, scan.ncm_id) && !@has_duplicate_data.include?(scan.ncm_id)
        @has_duplicate_data << scan.ncm_id
        puts "NCM #{ scan.ncm_id } has duplicate scans."
      end
    end
  end

end