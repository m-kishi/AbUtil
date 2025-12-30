#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'csv'
require '../utils/utils.rb'

# 支出情報
expenses = []

# DBファイル読み込み
abook = ENV["db_file"]
CSV.foreach(abook) do |row|
  expenses << Expense.new(row[0], row[1], row[2], row[3].to_i)
end

# 名前、種別でグループ化
group_expense = []
group_by_name = expenses.group_by {|e| e.name }
group_by_name.each_key do |name|
  group_by_type = group_by_name[name].group_by {|e| e.type }
  group_by_type.each_key do |type|
    cost = group_by_type[type].inject(0) {|sum, e| sum + e.cost }
    group_expense << Expense.new(nil, name, type, cost)
  end
end

# 出力
name_width = group_expense.max_by {|e| e.name.mb_size } .name.mb_size
type_width = group_expense.max_by {|e| e.type.mb_size } .type.mb_size
cost_width = group_expense.max_by {|e| e.currency.mb_size } .currency.mb_size
group_expense.sort_by {|e| e.name }.each do |e|
  name = e.name.mb_ljust(name_width)
  type = e.type.mb_ljust(type_width)
  cost = e.currency.mb_rjust(cost_width)
  puts "#{name} #{type} #{cost}"
end
