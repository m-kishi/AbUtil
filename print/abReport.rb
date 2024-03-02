#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'sqlite3'
require 'thinreports'
require './abCurrency.rb'

######################################################################
# 収支表(月次)
######################################################################
report = Thinreports::Report.new(:layout => 'summary_list')
report.list(:summary_list) do |list|

  total = Hash.new(0)

  list.on_page_footer_insert do |footer|
    footer.item(:food).value = total[:food].to_currency
    footer.item(:otfd).value = total[:otfd].to_currency
    footer.item(:good).value = total[:good].to_currency
    footer.item(:frnd).value = total[:frnd].to_currency
    footer.item(:trfc).value = total[:trfc].to_currency
    footer.item(:play).value = total[:play].to_currency
    footer.item(:hous).value = total[:hous].to_currency
    footer.item(:engy).value = total[:engy].to_currency
    footer.item(:cnct).value = total[:cnct].to_currency
    footer.item(:medi).value = total[:medi].to_currency
    footer.item(:insu).value = total[:insu].to_currency
    footer.item(:othr).value = total[:othr].to_currency
    footer.item(:ttal).value = total[:ttal].to_currency
    footer.item(:earn).value = total[:earn].to_currency
    footer.item(:blnc).value = total[:blnc].to_currency

    total = Hash.new(0)
  end

  sql = File.open('summary.sql').read
  SQLite3::Database.new('abook.sqlite3') do |db|
    db.results_as_hash = true
    db.execute(sql) do |row|
      y = row["year"]
      m = row["month"]
      food = row["food"].to_i
      otfd = row["otfd"].to_i
      good = row["good"].to_i
      frnd = row["frnd"].to_i
      trfc = row["trfc"].to_i
      play = row["play"].to_i
      hous = row["hous"].to_i
      engy = row["engy"].to_i
      cnct = row["cnct"].to_i
      medi = row["medi"].to_i
      insu = row["insu"].to_i
      othr = row["othr"].to_i
      ttal = row["ttal"].to_i
      earn = row["earn"].to_i
      blnc = row["blnc"].to_i

      list.add_row month: "#{y}/#{m}",
                   food: food.to_currency,
                   otfd: otfd.to_currency,
                   good: good.to_currency,
                   frnd: frnd.to_currency,
                   trfc: trfc.to_currency,
                   play: play.to_currency,
                   hous: hous.to_currency,
                   engy: engy.to_currency,
                   cnct: cnct.to_currency,
                   medi: medi.to_currency,
                   insu: insu.to_currency,
                   othr: othr.to_currency,
                   ttal: ttal.to_currency,
                   earn: earn.to_currency,
                   blnc: blnc.to_currency

      total[:food] += food
      total[:otfd] += otfd
      total[:good] += good
      total[:frnd] += frnd
      total[:trfc] += trfc
      total[:play] += play
      total[:hous] += hous
      total[:engy] += engy
      total[:cnct] += cnct
      total[:medi] += medi
      total[:insu] += insu
      total[:othr] += othr
      total[:ttal] += ttal
      total[:earn] += earn
      total[:blnc] += blnc
    end
  end
end
report.generate(:filename => 'summary.pdf')


######################################################################
# 収支表(年次)
######################################################################
report = Thinreports::Report.new(:layout => 'balance_list')
report.list(:balance_list) do |list|

  sub   = Hash.new(0)
  total = Hash.new(0)

  list.on_page_footer_insert do |footer|
    footer.item(:earn   ).value = sub[:earn   ].to_currency
    footer.item(:bonus  ).value = sub[:bonus  ].to_currency
    footer.item(:expense).value = sub[:expense].to_currency
    footer.item(:special).value = sub[:special].to_currency
    footer.item(:balance).value = sub[:balance].to_currency
    footer.item(:finance).value = sub[:finance].to_currency

    sub = Hash.new(0)
  end

  list.on_footer_insert do |footer|
    footer.item(:earn   ).value = total[:earn   ].to_currency
    footer.item(:bonus  ).value = total[:bonus  ].to_currency
    footer.item(:expense).value = total[:expense].to_currency
    footer.item(:special).value = total[:special].to_currency
    footer.item(:balance).value = total[:balance].to_currency
    footer.item(:finance).value = total[:finance].to_currency
  end

  sql = File.open('balance.sql').read
  SQLite3::Database.new('abook.sqlite3') do |db|
    db.results_as_hash = true
    db.execute(sql) do |row|
      report.page.list(:balance_list) do |list|
        year    = row["year"   ]
        earn    = row["earn"   ].to_i
        bonus   = row["bonus"  ].to_i
        expense = row["expense"].to_i
        special = row["special"].to_i
        balance = row["balance"].to_i
        finance = row["finance"].to_i

        list.add_row year: year,
                     earn: earn.to_currency,
                     bonus: bonus.to_currency,
                     expense: expense.to_currency,
                     special: special.to_currency,
                     balance: balance.to_currency,
                     finance: finance.to_currency

        sub[:earn   ] += earn
        sub[:bonus  ] += bonus
        sub[:expense] += expense
        sub[:special] += special
        sub[:balance] += balance
        sub[:finance] += finance

        total[:earn   ] += earn
        total[:bonus  ] += bonus
        total[:expense] += expense
        total[:special] += special
        total[:balance] += balance
        total[:finance] += finance
      end
    end
  end
end
report.generate(:filename => 'balance.pdf')
