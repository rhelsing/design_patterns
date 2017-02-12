#decorator pattern, adding or removing functionality to and from an object
#very useful for benadmin products

# decorate a base product w/ features from every product, define the new product as a type and use everywhereo

#the Decorator pattern helps the person who is try- ing to build all of this functionality neatly separate out the various concerns
#The irritating moment comes when someone tries to assemble all of these little building block classes into a working whole. (Thus the builder pattern)

#It offers an alternative to creating a monolithic “kitchen sink” object that supports every possible feature or a whole forest of classes and subclasses to cover every possible combination of features.
require 'forwardable'

class SimpleWriter
  def initialize(path)
    @file = File.open(path, 'w')
  end
  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end
  def pos
    @file.pos
  end
  def rewind
    @file.rewind
  end
  def close
    @file.close
  end
end


class WriterDecorator
  extend Forwardable
  def_delegators :@real_writer, :write_line, :rewind, :pos, :close #pass up to real_writer

  def initialize(real_writer)
    @real_writer = real_writer
  end
end

class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end
  def write_line(line)
    @real_writer.write_line("#{@line_number}: #{line}")
    @line_number += 1
  end
end

writer = NumberingWriter.new(SimpleWriter.new('test.txt'))
writer.write_line('Hello out there')

class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.new}: #{line}")
  end
end

writer = TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('test.txt')))
writer.write_line('Hello out there')


#Better w/ modules:
module TimeStampingWriterM
  def write_line(line)
    super("#{Time.new}: #{line}")
  end
end

module NumberingWriterM
  attr_reader :line_number
  def write_line(line)
    @line_number = 1 unless @line_number
    super("#{@line_number}: #{line}")
    @line_number += 1
  end
end

w = SimpleWriter.new('test.txt')
w.extend(NumberingWriterM)
w.extend(TimeStampingWriterM)
w.write_line('hey')
