require 'gnuplot'

data = { all: {}, men: {}, women: {} }

# Place Num  Chip       Lname     Fname     Country Division Div  Div  Sex  Sex      10Km       21Km       30Km       40Km       Pace
# ["1", "3", "2:15:35", "Chebet", "Wilson", "KEN", "MElite", "1", "8", "1", "11507", "0:31:50", "1:08:45", "1:37:47", "2:09:49", "5:11"]
IO.foreach(ARGV[0]) do |line|
  cols = line.split(/\s+/)
  time = cols[2].split(':')
  time = time[0] + '.' + (time[1].to_i / 10 * 10).to_s

  all = data[:all][time] || 0
  data[:all][time] = all + 1
  if cols[6][0] == 'M'
    men = data[:men][time] || 0
    data[:men][time] = men + 1
  end
  if cols[6][0] == 'W'
    women = data[:women][time] || 0
    data[:women][time] = women + 1
  end
end

p data

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|  
    plot.title  'Honolulu Marathon Finishers Graph'
    plot.xlabel 'Time'
    plot.ylabel 'Number of finishers'
    plot.terminal :png
    plot.output ARGV[1]
    plot.style 'fill solid'
    plot.xrange '[2:15]'
    plot.yrange '[0:1200]'

#    x = (0..50).collect { |v| v.to_f }
#    y = x.collect { |v| v ** 2 }

#    plot.data << Gnuplot::DataSet.new([data[:all].keys, data[:all].values]) do |ds|
#      ds.with = :boxes
#      ds.title = 'All'
#    end
    plot.data << Gnuplot::DataSet.new([data[:men].keys, data[:men].values]) do |ds|
      ds.with = :boxes
      ds.title = 'Men'
      ds.linecolor = 'rgbcolor "turquoise"'
    end
#    plot.data << Gnuplot::DataSet.new([data[:women].keys, data[:women].values]) do |ds|
#      ds.with = :boxes
#      ds.title = 'Women'
#      ds.linecolor = 'rgbcolor "magenta"'
#    end
#    plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
#      ds.with = :boxes
#      ds.notitle
#    end
  end
end
