#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require './abExten.rb'

# 支出情報構造体
Expense = Struct.new(:date, :name, :type, :cost) do
  def curr
    cost.to_currency
  end
end

# Abook.db読み込み
abook = ENV["db_file"]
expenses = []
File.open(abook, "r") do |f|
  f.each_line do |line|
    line = line.gsub("\"", "")
    args = line.split(",")
    expenses << Expense.new(args[0], args[1], args[2], args[3].to_i)
  end
end

# 名前、種別でグループ化
gexps = []
gnobj = expenses.group_by {|e| e.name }
gnobj.each_key do |nkey|
  gtobj = gnobj[nkey].group_by {|e| e.type }
  gtobj.each_key do |tkey|
    cost = gtobj[tkey].inject(0) {|sum, e| sum + e.cost }
    gexps << Expense.new(nil, nkey, tkey, cost)
  end
end

# 出力
nmax = gexps.max_by {|e| e.name.mb_size } .name.mb_size
tmax = gexps.max_by {|e| e.type.mb_size } .type.mb_size
cmax = gexps.max_by {|e| e.curr.mb_size } .curr.mb_size
gexps.sort_by {|e| e.name }.each do |e|
  name = e.name.mb_ljust(nmax)
  type = e.type.mb_ljust(tmax)
  cost = e.curr.mb_rjust(cmax)
  puts "#{name} #{type} #{cost}"
end
