require 'date'

module Nodes

  attr_accessor :keys

  def initialize
    @keys ||= []
  end

  #def self.included(base)
  #  base.after_find :load
  #  base.before_save :store
  #end

  def to_class(s)
    if valid_date_time?(s)
      Time.strptime(s, '%Y-%m-%d.%H:%M:%S').to_i
    elsif valid_date?(s)
      Date.strptime(s, '%Y-%m-%d').to_i
    elsif valid_time?(s)
      Time.strptime(s, '%H:%M:%S').to_i
    elsif valid_integer?(s)
      s.to_i
    elsif valid_float?(s)
      s.to_f
    else
      s
    end
  end

  def to_string(v)

  end

  def valid_integer?(s)
    s =~ /^[-+]?[0-9]*$/
  end

  def valid_float?(s)
    s =~ /^[-+]?[0-9]*\.?[0-9]+$/
  end

  def valid_date_time?(s, format='%Y-%m-%d.%H:%M:%S')
    Date.strptime(s,format) rescue false
  end


  def valid_date?(s, format='%Y-%m-%d')
    Date.strptime(s,format) rescue false
  end


  def valid_time?(s, format='%H:%M:%S')
    Time.strptime(s,format) rescue false
  end



end
