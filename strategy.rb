#extract various strategies for dealing with the data held by a class into its own implementation :)

#Automations if each handler has its own domain and data stored in object relates to implementation and can be arbitrary.
#Functional if it doesn't change existing data but only creates new..intermediate step to approve changes that would be made to data?

#Can be sub-classed if share common defaults
# class Formatter
#   def output_report( title, text )
#     raise 'Abstract method called'
#   end
# end

class HTMLFormatter #< Formatter
  def output_report( title, text )
    puts('<html>')
    puts('  <head>')
    puts("    <title>#{title}</title>")
    puts('  </head>')
    puts('  <body>')
    text.each do |line|
      puts("    <p>#{line}</p>" )
    end
    puts('  </body>')
    puts('</html>')
  end
end

class PlainTextFormatter #< Formatter
  def output_report(title, text)
    puts("***** #{title} *****")
    text.each do |line|
      puts(line)
    end
  end
end

class Report
  attr_reader :title, :text
  attr_accessor :formatter
  def initialize(formatter)
    @title = 'Monthly Report'
    @text =  [ 'Things are going', 'really, really well.' ]
    @formatter = formatter
  end
  def output_report
    @formatter.output_report( @title, @text )
  end
end

report = Report.new(HTMLFormatter.new)
report.output_report
report.formatter = PlainTextFormatter.new
report.output_report
