class String

	def remove( srt )
		sub srt, ""
	end

	def remove!( srt )
		sub! srt, ""
	end

  # кусок строки до первого вхождения s
	def before(s)
		i = index s
		i ? self[0...i] : self 
	end

	# кусок строки после первого вхождения s
	def after(s)
		i = index s
		len = s.size
		i ? self[(i+len)..-1] : self
	end

	# the array of strings between s1 и s2
	def between( s1, s2 )
		ss = split(s1)
		ss = ss.collect do |c|
			i = c.index s2
			c[0...i] if i
		end
		ss.compact
	end

	def tag( tag )
		between( "<#{tag}>", "</#{tag}>" )
	end

  def remove_first_line
    index_first_newline = (index("\n") || size - 1) + 1
    self[index_first_newline..-1]
  end
  
  # def <=>(other)
    # super.<=>(other)
    # other.nil? ? 0 : super(other)
  # end
  # include Comparable
  
end