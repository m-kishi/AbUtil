#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'csv'
require 'date'

# DBファイルパス
abook = ENV["db_file"]

# 開始メッセージ
puts "STR:" + Time.now.to_s
puts "=" * 31

# チェック処理
ok = true
curr = Date.new(2009, 4, 1)
CSV.foreach(abook).with_index(1) do |row, idx|
  _next = Date.parse(row[0])
  if curr > _next
    ok = false
    puts "l=#{idx}:#{row}"
  end
  curr = _next
end
puts "OK" if ok

# 終了メッセージ
puts "=" * 31
puts "END:" + Time.now.to_s
