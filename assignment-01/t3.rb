class Array
  def sum
    reduce(:+)
  end

  def mean
    sum.to_f / size
  end

  def var
    m = mean
    reduce(0){ |a,b| a + (b - m) ** 2 } / (size - 1)
  end

  def sd
    Math.sqrt(var)
  end
end

require 'gnuplot'
require 'distribution'

data = []

# Place Num  Chip       Lname     Fname     Country Division Div  Div  Sex  Sex      10Km       21Km       30Km       40Km       Pace
# ["1", "3", "2:15:35", "Chebet", "Wilson", "KEN", "MElite", "1", "8", "1", "11507", "0:31:50", "1:08:45", "1:37:47", "2:09:49", "5:11"]
IO.foreach(ARGV[0]) do |line|
  cols = line.split(/\s+/)
  time = cols[2].split(':')
  time = (time[0].to_i * 60 * 60) + (time[1].to_i * 60) + time[2].to_i
  data << time
end

all_cdf = Distribution::Normal.cdf(data.to_scale)
p all_cdf

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|  
    plot.title  'Honolulu Marathon Finishers Graph'
    plot.xlabel 'Time'
    plot.ylabel 'Number of finishers'
    plot.terminal :png
    plot.output ARGV[1]
    plot.style 'fill solid'
#    plot.xrange '[2:15]'
#    plot.yrange '[0:1200]'

    plot.data << Gnuplot::DataSet.new([(0..cdf.size), cdf.values]) do |ds|
      ds.with = :line
#      ds.title = 'CDF'
    end
  end
end
