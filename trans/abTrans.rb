#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

# 支出情報構造体
Expense = Struct.new(:date, :name, :type, :cost) do

  def translated_cost
    base = 0.0
    case
    when cost <    100; base =    100.0;
    when cost <   1000; base =    100.0;
    when cost <  10000; base =   1000.0;
    when cost < 100000; base =  10000.0;
    else                base = 100000.0;
    end
    (slapdash(cost / base) * base).to_i
  end

  def slapdash(value)
    case rand(1..3)
    when 1; value.ceil;
    when 2; value.floor;
    when 3; value.round;
    end
  end
end

# abook.db読み込み
idx = 0
expenses = []
File.open("abook.db", "r") do |f|
  f.each_line do |line|
    idx = idx + 1
    line = line.gsub("\"", "")
    args = line.split(",")
    if args[1] == "電気代" ||
       args[1] == "ガス代" ||
       args[1] == "水道代"
      name = args[1]
    else
      name = sprintf("NAME%04d", idx)
    end
    expenses << Expense.new(args[0], name, args[2], args[3].to_i)
  end
end

# 出力
expenses.each do |exp|
  puts "\"#{exp.date}\",\"#{exp.name}\",\"#{exp.type}\",\"#{exp.translated_cost}\""
end
