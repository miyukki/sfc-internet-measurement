require 'sqlite3'
require 'gnuplot'

db = SQLite3::Database.new 'twitter.db'

db.execute('SELECT users.id, user_names.screen_name, users.followings, users.followers FROM users LEFT JOIN user_names ON user_names.user_id = users.id ORDER BY users.followers DESC LIMIT 50') do |row|
  puts "#{row[1]}(#{row[0]}) followings:#{row[2]} followers:#{row[3]}"
end
