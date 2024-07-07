#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'date'
require './abModule.rb'

# 今月の支出情報
dt = Date.today

# Abook.db読み込み
db = ENV["db_file"]
abook = AbUtil::Abook.new(db, dt)

# 今月の食費
food = abook.get(:food).to_currency

# 今週あと(食費)
food_ramain = abook.remain_food.to_currency

# 今月の外食費
otfd = abook.get(:otfd).to_currency

# 今週あと(外食費)
otfd_remain = abook.remain_otfd.to_currency

# 今月の収入
blnc = abook.get_blnc.to_currency

# 年度収支
annual = abook.get_annual.to_currency

# 仮表記
assumed = (dt <= Date.new(dt.year, dt.month, 20)) ? "(仮)" : ""

# ##################################################
# 食費残の求め方
# 今月の休日の日数を求める(祝日も含める)
#   ¥7,500 / 月休日 = 1日の予算
# 今週の休日の日数を求める(祝日も含める)
#   1日の予算 * 週休日 = 週の予算
# 今週の食費を求める
#   支出情報.filter(今週内かつ食費).sum
# 週の予算 - 今週の食費 = 食費残
# ##################################################
# 外食費残の求め方
# 今月の平日の日数を求める(祝日も除く)
#   ¥7,500 / 月平日 = 1日の予算
# 今週の平日の日数を求める(祝日も除く)
#   1日の予算 * 週平日 = 週の予算
# 今週の外食費を求める
#   支出情報.filter(今週内かつ外食費).sum
# 週の予算 - 今週の外食費 = 外食費残
# ##################################################

# HTML
puts "<!DOCTYPE html>"
puts "<html lang=\"ja\">"
puts "<head>"
puts "  <title>AbPhone</title>"
puts "  <meta charset=\"UTF-8\">"
puts "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />"
puts "  <style>"
puts "    h1 { font-size: 1.5rem; }"
puts "    table.phone {"
puts "      font-size: 1.25rem;"
puts "      font-weight: bold;"
puts "      width: 90%;"
puts "      margin: auto;"
puts "      table-layout: fixed;"
puts "      border-collapse: collapse;"
puts "    }"
puts "    tr { border-bottom: 1px dotted #000000; }"
puts "    tr.type { background-color: #87CEEB; }"
puts "    tr.last { border-bottom: none !important; }"
puts "    td.type { width: 55%; }"
puts "    td.remain { text-align: right; }"
puts "    td.currency {"
puts "      width: 45%;"
puts "      text-align: right;"
puts "    }"
puts "  </style>"
puts "</head>"
puts "<body>"
puts "  <main>"
puts "    <h1>#{dt.strftime('%Y年%m月')}</h1>"
puts "    <table class=\"phone\">"
puts "      <tr class=\"type\"><td class=\"type\">食費</td><td class=\"currency\">&yen;#{food}</td></tr>"
puts "      <tr><td class=\"type remain\">今週あと</td><td class=\"currency\">&yen;#{food_ramain}</td></tr>"
puts "      <tr class=\"type\"><td class=\"type\">外食費</td><td class=\"currency\">&yen;#{otfd}</td></tr>"
puts "      <tr><td class=\"type remain\">今週あと</td><td class=\"currency\">&yen;#{otfd_remain}</td></tr>"
puts "      <tr class=\"type\"><td class=\"type\">収支#{assumed}</td><td class=\"currency\">&yen;#{blnc}</td></tr>"
puts "      <tr class=\"last\"><td class=\"type remain\">年度収支</td><td class=\"currency\">&yen;#{annual}</td></tr>"
puts "    </table>"
puts "  </main>"
puts "</body>"
puts "</html>"
