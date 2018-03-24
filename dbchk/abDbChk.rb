#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'date'

puts "STR:" + Time.now.to_s
puts "=" * 31

ok = true
dtCurr = Date.new(2009,4,1)
File.open("abook.db", "r") do |f|
  f.each_line.with_index(1) do |line, idx|
    line = line.gsub("\"", "").chomp
    dtNext = Date.parse(line.split(",")[0])
    if dtCurr > dtNext
      ok = false
      puts "l=#{idx}:'#{line}'"
    end
    dtCurr = dtNext
  end
end
puts "OK" if ok

puts "=" * 31
puts "END:" + Time.now.to_s
