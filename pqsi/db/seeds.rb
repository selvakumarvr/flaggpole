# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@customer   = Customer.create(:name => "ABC Corp")
@customer2  = Customer.create(:name => "XYZ Corp")

@location = Location.create(:name => "Headquarters", :customer => @customer )

@ncm = Ncm.create(
        :ncm_number                  => '2011 121',
        :description                 => 'Description',
        :location                    => @location,
        :clipboard                   => 'Q1',
        :sqe_pqe                     => 'SQE PQE Guy',
        :mi_name                     => 'MI Guy',
        :work_instructions           => 'Do something awesome',
        :part_name                   => 'PX123',
        :report_emails               => 'mr@webdesigncompany.net',
        :customer                    => @customer )

@user = User.create(
          :first_name             => "Melvin", 
          :last_name              => "Ram",
          :email                  => "mr@webdesigncompany.net",
          :password               => "password",
          :password_confirmation  => "password",
          :customer               => @customer,
          :level                  => "volcanic" )

@user2 = User.create(
          :first_name             => "Data Entry", 
          :last_name              => "Person",
          :email                  => "pqsi_data_entry@webdesigncompany.net",
          :password               => "password",
          :password_confirmation  => "password",
          :customer               => @customer,
          :level                  => "pqsi_data_entry" )

Permission.create(:user => @user2, 
                  :permissionable_type => 'ncm', 
                  :permissionable_id => @ncm.id)


Random.rand(1000).times do |i|
  @scan = Scan.create(
    :lot_number               => 'Lot AAA',
    :serial                   => "AAA",
    :ipn                      => '',
    :ncm                      => @ncm,
    :manufacturing_date       => Date.yesterday,
    :part_number              => "DA",
    :scanned_on               => Date.yesterday,
    :quantity                 => @q = Random.rand(1000),
    :reject_reason_1_label    => 'Something Wrong',
    :reject_reason_1_quantity => Random.rand( @q / 5 )
  )
end

Random.rand(1000).times do |i|
  Scan.create(
    :lot_number               => "#{i}",
    :lot_number               => 'Lot AAA',
    :serial                   => "AAA-#{i}",
    :ipn                      => '',
    :ncm                      => @ncm,
    :manufacturing_date       => Date.today,
    :part_number              => "DA-#{i}",
    :scanned_on               => Date.today,
    :quantity                 => @q = Random.rand(1000),
    :reject_reason_1_label    => 'Something Wrong',
    :reject_reason_1_quantity => Random.rand( @q / 5 )
  )
end
