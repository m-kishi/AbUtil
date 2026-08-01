#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

# 支出情報
class Expense

  # getter
  attr_reader :date, :name, :type, :cost

  # コンストラクタ
  def initialize(date, name, type, cost)
    @date = date
    @name = name
    @type = type
    @cost = cost
  end

  # 通貨形式
  def currency
    @cost.to_currency('¥')
  end

end

class Integer

  # 通貨形式
  def to_currency(symbol = nil)
    symbol = '\\' if symbol.nil?
    if self >= 0
      symbol + self.to_s.reverse.gsub(/(\d{3})(?=\d)/,'\1,').reverse
    else
      '-' + symbol + self.abs.to_s.reverse.gsub(/(\d{3})(?=\d)/,'\1,').reverse
    end
  end

end

class String

  # マルチバイトサイズ
  def mb_size
    each_char.map {|c| c.bytesize == 1 ? 1 : 2 }.reduce(0, &:+)
  end

  # マルチバイトの左揃え
  def mb_ljust(width, padding=' ')
    output_width = mb_size
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end

  # マルチバイトの右揃え
  def mb_rjust(width, padding=' ')
    output_width = mb_size
    padding_size = [0, width - output_width].max
    padding * padding_size + self
  end

end