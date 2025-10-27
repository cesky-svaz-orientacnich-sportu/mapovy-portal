# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

set :output, nil

every 1.day, at: '2:15 am' do
  rake 'oris:events'
end

every 1.day, at: '3:15 am' do
  rake 'oris:clubs'
end

every 1.day, at: '4:15 am' do
  rake 'oris:users'
end

every 1.day, at: '5:15 am' do
  rake "reminders:send"
end

every 1.day, at: '6:15 am' do
  rake 'maps:embargo'
end
