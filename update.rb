#!/usr/bin/env ruby
ROW_SIZE = 80

class String
  COLORS = {
    :red => "\033[31m",
    :green => "\033[32m",
    :yellow => "\033[33m",
    :blue => "\033[34m"
  }
  def colorize(color)
    "#{COLORS[color]}#{self}\033[0m"
  end
end

def puts_section(info, &block)
  puts info
  puts "-"*ROW_SIZE
  yield block
  puts "-"*ROW_SIZE
  puts ""
end

def puts_line(info, &block)
  print info
  rsize = ROW_SIZE - info.length
  success = yield block
  if success == false
    puts "[Failed]".rjust(rsize).colorize(:red)
  else
    puts "[Done]".rjust(rsize).colorize(:green)
  end
end

def puts_line_with_yn(info, &block)
  print info
  rsize = ROW_SIZE - info.length
  success = yield block
  if success == false
    puts "[No]".rjust(rsize).colorize(:red)
  else
    puts "[Yes]".rjust(rsize).colorize(:green)
  end
end

def replace_file(file_name, from, to)
  File.open(file_name, "r+") do |f|
    out = ""
    f.each do |line|
        out << line.gsub(from, to)
    end
    f.pos = 0
    f.print out
    f.truncate(f.pos)
  end
end

puts "Now Updateing OneTripWeb..."
puts "="*ROW_SIZE
puts ""

puts_section "Checking Package Dependencies..." do
  pkg_exist = true
  [["bundle","Bundler"],["python","Python 2.5+"],["memcached","Memcached 1.4+"],["convert","ImageMagick 6.5+"]].each do |item|
    puts_line_with_yn item[1] do
      if `which #{item[0]}` == ""
        pkg_exist = false
        false
      else
        true
      end
    end
  end

  exit(0) if pkg_exist == false
end

puts_line "Install Gems..." do
  `bundle install`
end

puts_line "Database Update..." do
  `bundle exec rake db:migrate RAILS_ENV=production`
end

puts_line "Clear logs" do
  `bundle exec rake log:clear RAILS_ENV=production`
end

puts_line "Compile All The Assets" do
  `bundle exec rake assets:clean RAILS_ENV=production`
  `bundle exec rake assets:precompile RAILS_ENV=production`
end

puts_line "Restart Thin Server" do
  `thin -C config/thin.yml restart`
end

puts ""
puts "OneTripWeb Successfully Installed."