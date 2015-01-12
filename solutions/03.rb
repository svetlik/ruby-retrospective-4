class String
  def to_bool
    downcase == 'true'
  end
end

module RBFS
  attr_accessor :data
  attr_reader :data_type

  class File
    def self.parse(string_data)
      parsed_data_type = string_data.split(':')[0]
      parsed_data = string_data.split(':')[1]
      data = string_to_data_type(parsed_data_type, parsed_data)
      file = RBFS::File.new(data)
    end

    def initialize(*data)
      @data = data[0]
    end

    def data
      @data
    end

    def data=(new_data)
      @data = new_data
    end

    def data_type
      case @data
      when Fixnum, Bignum, Float then :number
      when NilClass then :nil
      when String then :string
      when Symbol then :symbol
      when TrueClass, FalseClass then :boolean
      end
    end

    def serialize
      "#{data_type}:#{data}"
    end

    private

    def string_to_data_type(data_type, data)
      case data_type
      when 'symbol' then data = data.to_sym
      when 'number' then data = data.to_f
      when 'boolean' then data = data.to_bool
      end
      data
    end
  end

  class Directory
    attr_reader :files
    attr_reader :directories

    def initialize
      @files = {}
      @directories = {}
    end

    def add_file(name, file)
      @files[name] = file
    end

    def add_directory(name, directory = RBFS::Directory.new)
      @directories[name] = directory
    end

    def [](name)
      if @directories.keys.include? name
        @directories[name]
      elsif @files.keys.include? name
        @files[name]
      else
        nil
      end
    end

    def serialize
      result = "#{@files.count}:"
      @files.each do |key, value|
        result << "#{key}:#{value.serialize.size}:#{value.serialize}"
      end
      result << "#{@directories.count}:"
      @directories.each do |key, value|
        result << "#{key}:#{value.serialize.size}:#{value.serialize}"
      end
      result
    end

    def self.parse(string_data)
      # result_dir = RBFS::Directory.new
      # info = string_data.split(':')
      # # "2:README:19:string:Hello world!spec.rb:20:string:describe RBFS1:rbfs:4:0:0:"
      # # "0:1:directory1:40:0:1:directory2:22:1:README:9:number:420:"
      # # "0:0:"
      # # "1:README:19:string:Hello world!"
      # # file_size = string_data.split(':')[0]
      # file_count = info[0] # => 2
      # file_info = info.values_at(1..file_count.to_i*3+1) # =>
      # file_count.to_i.times {
      #   file = RBFS::File.parse("#{file_info[3]}:#{file_info[4]}")
      #   result_dir.add_file(file_info, file)
      # }
      # result_dir
    end

    def files
      @files
    end

    def directories
      @directories
    end
  end
end