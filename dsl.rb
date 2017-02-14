#simple program, in a domain language, that is expanded to do more complex things

#if security is an issue, stay away from internal DSLs—far, far away. After all, the whole point of an internal DSL is that you take some arbitrary code that someone else wrote and suck it into your program. That requires a toothbrush- sharing level of trust.

class Backup
  include Singleton
  attr_accessor :backup_directory, :interval
  attr_reader :data_sources
  def initialize
    @data_sources = []
    @backup_directory = '/backup'
    @interval = 60
  end
  def backup_files
    this_backup_dir = Time.new.ctime.tr(' :','_')
    this_backup_path = File.join(backup_directory, this_backup_dir)
    @data_sources.each {|source| source.backup(this_backup_path)}
  end
  def run
    while true
      backup_files
      sleep(@interval*60)
    end
  end
end

class DataSource
  attr_reader :directory, :finder_expression
  def initialize(directory, finder_expression)
    @directory = directory
    @finder_expression = finder_expression
  end
  def backup(backup_directory)
    files=@finder_expression.evaluate(@directory)
    files.each do |file|
      backup_file( file, backup_directory)
    end
  end
  def backup_file( path, backup_directory)
    copy_path = File.join(backup_directory, path)
    FileUtils.mkdir_p( File.dirname(copy_path) )
    FileUtils.cp( path, copy_path)
  end
end

def backup(dir, find_expression=All.new)
  Backup.instance.data_sources << DataSource.new(dir, find_expression)
end
def to(backup_directory)
  Backup.instance.backup_directory = backup_directory
end
def interval(minutes)
  Backup.instance.interval = minutes
end
eval(File.read('dsl_input.pr'))
Backup.instance.run
