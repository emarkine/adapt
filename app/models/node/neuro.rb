class Node::Neuro < Node

  def start

  end

  def stop

  end

  def run
    self.edges.each do |edge|
      puts edge
    end
  end

end