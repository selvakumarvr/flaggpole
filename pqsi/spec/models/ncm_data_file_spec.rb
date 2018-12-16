require 'spec_helper'

describe NcmDataFile do
  
  describe "scan_exists" do
    it "should be able to tell if a scan already exists" do
      @scan = create(:scan)
      
      @ncm_data_file = NcmDataFile.new
      @ncm_data_file.scan_exists?(@scan.row_id, @scan.ncm_id).should be_true
      @ncm_data_file.scan_exists?(@scan.row_id, 2312313).should be_false
    end
  end
  
end