#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'date'
require_relative '../utils/abExten.rb'

# AbUtilモジュール
module AbUtil

  # クラス
  class Abook

    # 一ヶ月の食費
    BUDGET_FOOD = 7500

    # 一ヶ月の外食費
    BUDGET_OTFD = 7500

    # 種別
    Types = {
      :food => "食費",
      :otfd => "外食費",
      :good => "雑貨",
      :frnd => "交際費",
      :trfc => "交通費",
      :play => "遊行費",
      :hous => "家賃",
      :engy => "光熱費",
      :cnct => "通信費",
      :medi => "医療費",
      :insu => "保険料",
      :othr => "その他",
      :earn => "収入",
      :bnus => "特入",
      :spcl => "特出",
    }

    # 休日(0:日曜日 6:土曜日)
    HOLIDAY = [ 0, 6]

    # 平日(1:月曜日〜5:金曜日)
    WEEKDAY = [ 1, 2, 3, 4, 5]

    # 祝日
    PUBLIC_HOLIDAY = [
      Date.parse("2024-01-01"),
      Date.parse("2024-01-08"),
      Date.parse("2024-02-12"),
      Date.parse("2024-02-23"),
      Date.parse("2024-03-20"),
      Date.parse("2024-04-29"),
      Date.parse("2024-05-03"),
      Date.parse("2024-05-06"),
      Date.parse("2024-07-15"),
      Date.parse("2024-08-12"),
      Date.parse("2024-09-16"),
      Date.parse("2024-09-23"),
      Date.parse("2024-10-14"),
      Date.parse("2024-11-04"),
    ]

    # 支出情報構造体
    Expense = Struct.new(:date, :name, :type, :cost, :note)

    # コンストラクタ
    def initialize(db, dt)
      @dt = dt
      @expenses = []
      File.open(db, "r") do |f|
        f.each_line do |line|
          line = line.gsub("\"", "")
          args = line.split(",")
          if range_year.cover?(Date.parse(args[0]))
            @expenses << Expense.new(args[0], args[1], args[2], args[3].to_i, args[4].chomp)
          end
        end
      end
    end

    # 年度範囲を取得
    def range_year
      y = @dt.year
      y -= 1 if (1..3).include?(@dt.month)
      (Date.new(y, 4, 1))..(Date.new(y+1, 3, 31))
    end

    # 当月範囲を取得
    def range_month
      dt_str = Date.new(@dt.year, @dt.month)
      dt_end = Date.new(@dt.year, @dt.month, -1)
      dt_str..dt_end
    end

    # 一週間の範囲を取得(月〜日)
    def range_week
      dt_str = Date.new(@dt.year, @dt.month)
      dt_end = Date.new(@dt.year, @dt.month, -1)
      monday = @dt - ((@dt.wday + 6) % 7)
      sunday = monday + 6
      dt_str = monday if dt_str < monday
      dt_end = sunday if sunday < dt_end
      dt_str..dt_end
    end

    # 種別で絞り込み
    def filter(type, range = nil)
      if range
        @expenses.filter { |exp| range.cover?(Date.parse(exp.date)) && exp.type == Types[type] }
      else
        @expenses.filter { |exp| exp.type == Types[type] }
      end
    end

    # 種別の合計
    def get(type)
      filter(type, range_month).sum { |exp| exp.cost }
    end

    # 合計対象の種別
    def ttal_types
      types = Types.keys
      types.delete(:earn)
      types.delete(:bnus)
      types.delete(:spcl)
      types
    end

    # 合計を取得
    def get_ttal
      ttal_types.inject(0) { |ttal, type| ttal += filter(type, range_month).sum { |exp| exp.cost }}
    end

    # 収支を取得
    def get_blnc
      earn = get(:earn)
      earn - get_ttal
    end

    # 年度合計対象の種別
    def annual_types
      types = Types.keys
      types.delete(:earn)
      types.delete(:bnus)
      types
    end

    # 年度収支を取得
    def get_annual
      ttal = annual_types.inject(0) { |ttal, type| ttal += filter(type, range_year).sum { |exp| exp.cost }}
      earn = [:earn, :bnus].inject(0) { |earn, type| earn += filter(type, range_year).sum { |exp| exp.cost }}
      earn - ttal
    end

    # 休日数
    def get_holiday(range)
      range.filter { |dt| HOLIDAY.include?(dt.wday) || PUBLIC_HOLIDAY.include?(dt) }.length
    end

    # 一週間の食費
    def week_ttal_food
      filter(:food, range_week).sum { |exp| exp.cost }
    end

    # 今週あと(食費)
    def remain_food
      day_budget = BUDGET_FOOD / get_holiday(range_month)
      week_budget = day_budget * get_holiday(range_week)
      week_budget - week_ttal_food
    end

    # 平日数
    def get_weekday(range)
      range.filter { |dt| WEEKDAY.include?(dt.wday) && !PUBLIC_HOLIDAY.include?(dt) }.length
    end

    # 一週間の外食費
    def week_ttal_otfd
      filter(:otfd, range_week).sum { |exp| exp.cost }
    end

    # 一週間の予算(外食費)
    def remain_otfd
      day_budget = BUDGET_OTFD / get_weekday(range_month)
      week_budget = day_budget * get_weekday(range_week)
      week_budget - week_ttal_otfd
    end

  end

end