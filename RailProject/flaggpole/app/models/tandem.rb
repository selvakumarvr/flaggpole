require 'tandem_api'

module Tandem
  def self.table_name_prefix
    'tandem_'
  end

  def self.populate
    self.populate_countries
    self.populate_subdivisions
    self.populate_districts
    self.populate_schools
    self.populate_groups
    Organization.export_json
  end

  def self.populate_countries
    TandemApi.countries.each do |c|
      unless Tandem::Country.exists?(:key => c['id'])
        Tandem::Country.create!(
          :key => c['id'],
          :name => c['name']
        )
      end
    end
  end

  def self.populate_subdivisions
    #Tandem::Country.find_each do |country|
    Parallel.each(Tandem::Country.all, :in_threads => 2) do |country|
      ActiveRecord::Base.connection_pool.with_connection do
        TandemApi.subdivisions(country.key).each do |s|
          unless country.subdivisions.exists?(:key => s['id'])
            country.subdivisions.create!(
              :key => s['id'],
              :name => s['name']
            )
          end
        end
      end
    end
  end

  def self.populate_districts
    #Tandem::Subdivision.find_each do |subdivision|
    Parallel.each(Tandem::Subdivision.all, :in_threads => 4) do |subdivision|
      ActiveRecord::Base.connection_pool.with_connection do
        TandemApi.districts(subdivision.key).each do |d|
          unless subdivision.districts.exists?(:nces_id => d['nces_id'])
            subdivision.districts.create!(
              :nces_id => d['nces_id'],
              :name => d['name']
            )
          end

          # add as Organization if not exist
          unless Organization.exists?(:district_nces_id => d['nces_id'])
            # use create instead of create! because some districts the same name
            # and same name as the school. For example, "Calvary Christian Academy"
            Organization.create(
              :name => d['name'],
              :district_nces_id => d['nces_id']
            )
          end
        end
      end
    end
  end

  def self.populate_schools
    #Tandem::District.find_each do |district|
    Parallel.each(Tandem::District.all, :in_threads => 4) do |district|
      ActiveRecord::Base.connection_pool.with_connection do
        #puts "Getting schools in district #{district.nces_id}"
        schools = ::TandemApi.schools(district.nces_id)
        break if schools.nil?
        schools.each do |s|
          break if s.nil?
          break if s['name'].nil?
          #pp s
          #puts "school has nces_id #{s['nces_id']}"
          unless district.schools.exists?(:nces_id => s['nces_id'])
            district.schools.create! do |x|
              x.nces_id = s['nces_id']
              x.name = s['name']
              x.yearly_events_url = s['yearly_events_url'] if s['yearly_events_url']
              x.yearly_events_ical = s['yearly_events_ical'] if s['yearly_events_ical']
              x.yearly_events_xcal = s['yearly_events_xcal'] if s['yearly_events_xcal']
              x.events_url = s['events_url'] if s['events_url']
              x.events_ical = s['events_ical'] if s['events_ical']
              x.events_xcal = s['events_xcal'] if s['events_xcal']
            end
          end

          # add as Organization if not exist
          unless Organization.exists?(:nces_id => s['nces_id'])
            # create rather than create! to skip validations
            Organization.create(
              :name => s['name'],
              :nces_id => s['nces_id'],
              :district_nces_id => district.nces_id
            )
          end

        end
      end
    end
  end

  def self.populate_groups
    Parallel.each(Tandem::School.where('events_url IS NOT NULL'), :in_threads => 4) do |school|
      ActiveRecord::Base.connection_pool.with_connection do
        #puts "Getting groups for school #{school.nces_id}"
        groups = ::TandemApi.groups(school.nces_id)
        break if groups.nil?
        groups.each do |g|
          break if g.nil?
          break if g['name'].nil?
          #pp g
          #puts "group has nces_id #{g['nces_id']}"
          unless school.groups.exists?(:key => g['id'])
            school.groups.create! do |x|
              x.key = g['id']
              x.name = g['name']
              x.events_url = g['events_url'] if g['events_url']
              x.events_ical = g['events_ical'] if g['events_ical']
              x.events_xcal = g['events_xcal'] if g['events_xcal']
            end
          end
        end
      end
    end
  end

end
