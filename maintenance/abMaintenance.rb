#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

#支出情報構造体
Expense = Struct.new(:date, :name, :type, :cost)

#abook.db読み込み
expenses = []
File.open("abook.db") do |f|
  f.each_line do |line|
    line = line.gsub("\"", "")
    args = line.split(",")
    expenses << Expense.new(*args)
  end
end

#名前、種別でグループ化
pairs = []
gname_obj = expenses.group_by { |exp| exp.name }
gname_obj.each_key do |kname|
  gtype_obj = gname_obj[kname].group_by { |exp| exp.type }
  gtype_obj.each_key do |ktype|
    pairs << "#{kname}\t#{ktype}"
  end
end

#出力
pairs.sort.each { |elem| puts elem }
