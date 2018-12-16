require 'csv'

task :split_file => :environment do

  original = Rails.root + 'lib/tasks/IBC1440.csv'
  lines_per_file = 1000

  header_lines = 1
  lines = `cat #{original} | wc -l`.to_i - header_lines
  file_count = (lines / lines_per_file) + 1
  total_lines_per_file = 1000 + header_lines
  header = `head -n #{header_lines} #{original}`

  start = header_lines
  generated_files = []

  file_count.times do |i|
    finish = start + total_lines_per_file
    file = "#{original}-#{i}.csv"

    File.open(file,'w'){|f| f.write header }
    sh "tail -n #{lines - start} #{original} | head -n #{total_lines_per_file} >> #{file}"

    start = finish
    generated_files << file
  end

  generated_files

end

