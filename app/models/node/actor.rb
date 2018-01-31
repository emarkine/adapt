class Node::Actor < Node

  def start
    @action = File.read(self.file)
  end

  def stop

  end

  def run
    self.edges.each do |edge|
      puts edge
      eval @action
    end
  end

end