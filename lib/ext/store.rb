module Store
  STORE = "#{Rails.root}/store"

  attr_accessor :store_name, :file_to_save

  def self.included(base)
    base.after_create :create_store
    base.after_update :update_store
    base.after_destroy :destroy_store
    #base.before_save :save_file
  end

  def store
    File.expand_path("#{STORE}/#{self.class.name.downcase}")
  end

  def store_save_path
    self.name
  end

  def path
    File.expand_path("#{self.store}/#{self.store_save_path}")
  end

  def files(pattern = "*")
    list = []
    Dir.glob("#{path}/#{pattern}").each.collect do |file|
      list << File.basename(file) if File.file?(file)
      #lister << File.basename(file) if File.directory?(file) # todo различная обработка для файлов или директорий?
    end
    list
  end

  def shash_files
    s = ''
    files.each do |file|
      s << Digest::SHA256.hexdigest(file)
      s << Digest::SHA256.file("#{self.path}/#{file}").hexdigest
    end
    s.blank? ? s : Digest::SHA256.hexdigest(s)
  end

  def create_store
    Dir.mkdir(self.path) unless File.directory?(path)
  end

  def update_store
    unless self.id == self.store_save_path
      if !self.store_name.nil? && self.store_name != self.name
        old_path = File.expand_path("#{self.store}/#{self.store_name}")
        if !self.store_name.blank? && File.directory?(old_path)
          FileUtils.mv old_path, self.path
        else
          Dir.mkdir(self.path)
        end
      end
    end
  end

  def destroy_store
    FileUtils.rm_rf(self.path)
  end

  def file=(upload)
    if upload
      write_attribute(:file, sanitize_filename(upload.original_filename))
      self.file_to_save = upload
    else
      write_attribute(:file, nil)
      self.file_to_save = nil
    end
  end

  def save_file
    if self.file_to_save
      filename = "#{self.path}/#{self.file}"
      FileUtils.mkdir_p(File.dirname(filename)) unless File.exists?(File.dirname(filename))
      File.open(filename, "wb") { |f| f.write(self.file_to_save.read) }
    end
  end

  def delete_file(name)
    File.delete "#{self.path}/#{name}"
  end

  def sanitize_filename(filename)
    #File.basename(filename).sub(/[^\w\.\-]/, '_')
    filename
  end


  def yml
    self.attributes.to_yaml.remove_first_line
  end

end