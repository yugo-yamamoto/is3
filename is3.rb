#!/usr/bin/env ruby

require "pathname"

class Path
  def initialize(init_path)
    @current_path = "" 
    self.path = init_path unless init_path.nil?
  end
  def path=(value)
    return unless value 
    if value[0] == "/"
      @current_path = value[1..-1]    
    else
      @current_path += value  
    end
    @current_path = Pathname.new(@current_path).cleanpath.to_s
    if @current_path == "."
      @current_path = ""
      return 
    end
    @current_path += "/" unless @current_path[-1] == "/"
  end
  def path
    @current_path
  end
  def to_s
    @current_path
  end
end

class Ls
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    system("aws s3 #{args.join(" ")} s3://#{@path.path} | more")
  end
end

class Less
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    system("aws s3 cp s3://#{@path.path}#{args[1]} - | less")
  end
end

class Get
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    system("aws s3 cp s3://#{@path.path}#{args[1]} #{args[1]}")
  end
end

class Put
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    system("aws s3 cp #{args[1]} s3://#{@path.path}#{args[1]}")
  end
end

class Rm
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    system("aws s3 rm s3://#{@path.path}#{args[1]}")
  end
end

class Cd
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    @path.path = args[1]
  end
end

class Presign
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    system("aws s3 presign --expires-in 604800 s3://#{@path.path}#{args[1]}")
  end
end

class Pwd
  def initialize(path_obj)
    @path = path_obj 
  end
  def run(args)
    puts @path 
  end
  def show
    print @path 
  end
end

class Quit def run(args) exit end end

commands = {}
path = Path.new(ARGV[0])
commands["ls"] = Ls.new(path)
commands["cd"] = Cd.new(path)
commands["pwd"] = Pwd.new(path)
commands["less"] = Less.new(path)
commands["get"] = Get.new(path)
commands["put"] = Put.new(path)
commands["rm"] = Rm.new(path)
commands["presign"] = Presign.new(path)
commands["quit"] = Quit.new 
commands["exit"] = Quit.new 

loop do 
  commands["pwd"].show
  print ">"
  args = STDIN.gets.chomp.split(" ")
  if commands[args.first].nil?
    puts "input commmand below. #{commands.keys.join(",")}" 
  else
    commands[args.first].run(args)
  end
end

