class ObjectCache
  @@objects = {}

  def self.set(key, object)
    @@objects[key] = object
  end

  def self.get(key)
    @@objects[key]
  end

  def self.del(key)
    @@objects.delete(key)
  end

  def self.has?(key)
    @@objects.has_key?(key)
  end

end
