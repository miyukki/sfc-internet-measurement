require 'sqlite3'
require 'gnuplot'

db = SQLite3::Database.new 'twitter.db'

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.xlabel 'CCDF'
    plot.terminal :png
    plot.output ARGV[1]
    plot.style 'fill solid'
    plot.logscale

    followings_counts = Hash.new(0)
    followers_counts = Hash.new(0)
    db.execute('select followings, followers from users') do |row|
      followings_counts[row[0].to_i] += 1
      followers_counts[row[1].to_i] += 1
    end

    followings_x = []
    followings_y = []
    followings_sum = 0
    followings_counts.sort.each do |key, value|
      c = 1.0 - Float(followings_sum) / 41652230
      followings_x.push(key)
      followings_y.push(c)
      followings_sum += value
    end

    followers_x = []
    followers_y = []
    followers_sum = 0
    followers_counts.sort.each do |key, value|
      c = 1.0 - Float(followers_sum) / 41652230
      followers_x.push(key)
      followers_y.push(c)
      followers_sum += value
    end

    plot.data << Gnuplot::DataSet.new([followings_x, followings_y]) do |ds|
      ds.with = :points
      ds.title = 'Followings'
      ds.linecolor = 'rgbcolor "turquoise"'
    end
    plot.data << Gnuplot::DataSet.new([followers_x, followers_y]) do |ds|
      ds.with = :points
      ds.title = 'Followers'
      ds.linecolor = 'rgbcolor "magenta"'
    end
  end
end
