class Node::Nodes < Node

  def start
    @nodes = File.read(self.file)
  end

  def stop

  end

  def run
    puts 'nodes.run'
    self.edges.each do |edge|
      puts edge
      print 'Hello '
      eval @nodes
    end
  end

end