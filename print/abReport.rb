#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'sqlite3'
require 'thinreports'
require './abCurrency.rb'

######################################################################
# 収支表(月次)
######################################################################
report = ThinReports::Report.new(:layout => 'summary_list')
report.layout.config.list(:summary_list) do

  use_stores :total => Hash.new(0)

  events.on :page_footer_insert do |e|
    e.section.item(:food).value(e.store.total[:food].to_currency)
    e.section.item(:otfd).value(e.store.total[:otfd].to_currency)
    e.section.item(:good).value(e.store.total[:good].to_currency)
    e.section.item(:frnd).value(e.store.total[:frnd].to_currency)
    e.section.item(:trfc).value(e.store.total[:trfc].to_currency)
    e.section.item(:play).value(e.store.total[:play].to_currency)
    e.section.item(:hous).value(e.store.total[:hous].to_currency)
    e.section.item(:engy).value(e.store.total[:engy].to_currency)
    e.section.item(:cnct).value(e.store.total[:cnct].to_currency)
    e.section.item(:medi).value(e.store.total[:medi].to_currency)
    e.section.item(:insu).value(e.store.total[:insu].to_currency)
    e.section.item(:othr).value(e.store.total[:othr].to_currency)
    e.section.item(:ttal).value(e.store.total[:ttal].to_currency)
    e.section.item(:earn).value(e.store.total[:earn].to_currency)
    e.section.item(:blnc).value(e.store.total[:blnc].to_currency)
  end
end

cnt = 0
sql = File.open('summary.sql').read
SQLite3::Database.new('abook.sqlite3') do |db|
  db.results_as_hash = true
  db.execute(sql) do |row|
    if cnt % 12 == 0
      report.start_new_page
    end
    cnt = cnt + 1
    report.page.list(:summary_list) do |list|
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

      list.add_row :month => "#{y}/#{m}",
                   :food => food.to_currency,
                   :otfd => otfd.to_currency,
                   :good => good.to_currency,
                   :frnd => frnd.to_currency,
                   :trfc => trfc.to_currency,
                   :play => play.to_currency,
                   :hous => hous.to_currency,
                   :engy => engy.to_currency,
                   :cnct => cnct.to_currency,
                   :medi => medi.to_currency,
                   :insu => insu.to_currency,
                   :othr => othr.to_currency,
                   :ttal => ttal.to_currency,
                   :earn => earn.to_currency,
                   :blnc => blnc.to_currency

      list.store.total[:food] += food
      list.store.total[:otfd] += otfd
      list.store.total[:good] += good
      list.store.total[:frnd] += frnd
      list.store.total[:trfc] += trfc
      list.store.total[:play] += play
      list.store.total[:hous] += hous
      list.store.total[:engy] += engy
      list.store.total[:cnct] += cnct
      list.store.total[:medi] += medi
      list.store.total[:insu] += insu
      list.store.total[:othr] += othr
      list.store.total[:ttal] += ttal
      list.store.total[:earn] += earn
      list.store.total[:blnc] += blnc
    end
  end
end
report.generate(:filename => 'summary.pdf')


######################################################################
# 収支表(年次)
######################################################################
report = ThinReports::Report.new(:layout => 'balance_list')
report.layout.config.list(:balance_list) do

  use_stores :sub   => Hash.new(0),
             :total => Hash.new(0)

  events.on :page_footer_insert do |e|
    e.section.item(:earn   ).value(e.store.sub[:earn   ].to_currency)
    e.section.item(:bonus  ).value(e.store.sub[:bonus  ].to_currency)
    e.section.item(:expense).value(e.store.sub[:expense].to_currency)
    e.section.item(:special).value(e.store.sub[:special].to_currency)
    e.section.item(:balance).value(e.store.sub[:balance].to_currency)
    e.store.sub = Hash.new(0)
  end

  events.on :footer_insert do |e|
    e.section.item(:earn   ).value(e.store.total[:earn   ].to_currency)
    e.section.item(:bonus  ).value(e.store.total[:bonus  ].to_currency)
    e.section.item(:expense).value(e.store.total[:expense].to_currency)
    e.section.item(:special).value(e.store.total[:special].to_currency)
    e.section.item(:balance).value(e.store.total[:balance].to_currency)
  end
end
report.start_new_page

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

      list.add_row :year    => year,
                   :earn    => earn   .to_currency,
                   :bonus   => bonus  .to_currency,
                   :expense => expense.to_currency,
                   :special => special.to_currency,
                   :balance => balance.to_currency

      list.store.sub[:earn]    += earn
      list.store.sub[:bonus]   += bonus
      list.store.sub[:expense] += expense
      list.store.sub[:special] += special
      list.store.sub[:balance] += balance

      list.store.total[:earn]    += earn
      list.store.total[:bonus]   += bonus
      list.store.total[:expense] += expense
      list.store.total[:special] += special
      list.store.total[:balance] += balance
    end
  end
end
report.generate(:filename => 'balance.pdf')
