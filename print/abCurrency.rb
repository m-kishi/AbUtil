#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

class Integer
  
  # 通貨形式
  def to_currency()
    if self >= 0
      '\\' + self.to_s.reverse.gsub(/(\d{3})(?=\d)/,'\1,').reverse
    else
      '-\\' + self.abs.to_s.reverse.gsub(/(\d{3})(?=\d)/,'\1,').reverse
    end
  end
  
end
