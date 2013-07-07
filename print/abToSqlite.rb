#!/usr/bin/env ruby
# -* encoding: utf-8 -*-

require 'csv'

abook = ENV["ab_new"]
command = ENV["command"]

insert = <<_EOF_
INSERT INTO expenses ("date","name","type","cost") VALUES ('%s','%s','%s','%s');
_EOF_

File.open(command, 'a') do |f|
  CSV.foreach(abook) do |row|
    f.puts sprintf(insert, row[0], row[1], row[2], row[3])
  end
end
