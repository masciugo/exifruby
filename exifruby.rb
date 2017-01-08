#!/usr/bin/env ruby

require "thor"
require "mini_exiftool"
require "byebug"
require "pathname"

class MyCLI < Thor
  option :regexp, :required => true, desc: 'regular expression to detect datetime group (i.e. IMG-(\d{8}))'
  option :format, :required => true, desc: 'format of the detected datetime string (i.e. \'%Y%m%d\')'
  option :folderpath, :required => true, desc: 'relative directory path'
  desc "filename2datetime","extract date from filename by provided format"
  long_desc <<-LONGDESC
      extract date from filename by provided format

      For example:
        ./exifruby.rb filename2datetime --folderpath test --format '%Y%m%d' --regexp 'IMG-(\d{8})'
  LONGDESC
  def filename2datetime
    puts "Start ..."
    Dir[Pathname(options[:folderpath]) + "*.jpg"].each do |path|
      fn = File.basename(path)
      puts "Working on #{path} ..."
      regexp = Regexp.new(options[:regexp])
      if date_string = fn.match(regexp)[1]
        datetime = DateTime.strptime(date_string,options[:format])
        photo = MiniExiftool.new(path)
        photo.date_time_original = datetime
        photo.save!
      else
        puts "... no date found"
      end

    end
    puts "... ended."
  end
end

MyCLI.start(ARGV)
