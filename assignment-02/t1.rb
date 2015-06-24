require 'sqlite3'
require 'gnuplot'

data = []

IO.foreach(ARGV[0]) do |line|
  data.push line.split(/\s+/)
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    # plot.title  'Honolulu Marathon Finishers Graph'
    plot.xlabel 'Number of followings'
    plot.ylabel 'Number of followers'
    plot.terminal :png
    plot.output ARGV[1]
    plot.style 'fill solid'
    # plot.logscale
    # plot.logscale 'y'
    # plot.xrange '[0:10000]'
    # plot.yrange '[0:10000]'
    x = []
    y = []
    data.each do |row|
      x.push row[1]
      y.push row[2]
    end

    plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
      ds.with = :points
      # ds.title = 'Men'
      # ds.linecolor = 'rgbcolor "turquoise"'
    end
  end
end
