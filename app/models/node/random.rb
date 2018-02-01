class Node::Random < Node

  def start
    @action = File.read(self.file)
  end

  def stop

  end

  def run
    puts 'node.run'
    self.edges.each do |edge|
      puts edge
      print 'Hello '
      eval @action
    end
  end

end