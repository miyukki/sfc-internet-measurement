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

data = []
# Place Num  Chip       Lname     Fname     Country Division Div  Div  Sex  Sex      10Km       21Km       30Km       40Km       Pace
# ["1", "3", "2:15:35", "Chebet", "Wilson", "KEN", "MElite", "1", "8", "1", "11507", "0:31:50", "1:08:45", "1:37:47", "2:09:49", "5:11"]
IO.foreach(ARGV[0]) do |line|
  cols = line.split(/\s+/)
  time = cols[2].split(':')
  time = (time[0].to_i * 60 * 60) + (time[1].to_i * 60) + time[2].to_i

  if cols[6][0] == 'W'
    data << time
  end
end

p '平均値'
p data.inject(0.0){|r,i| r+=i }/data.size

p '中央値'
p data.size % 2 == 0 ? data[data.size/2 - 1, 2].inject(:+) / 2.0 : data[data.size/2]

p '標準偏差'
p data.sd

p '最大値'
p data.max

p '最小値'
p data.min
