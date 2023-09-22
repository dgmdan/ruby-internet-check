require 'open-uri'
require 'csv'
require 'date'

LOG_FILE = '/var/log/internet.log'
TEST_URL = 'https://www.yahoo.com/'
SECONDS_BETWEEN_TRIES = 5


def internet_connection?
  begin
    [true, nil] if OpenURI.open_uri(TEST_URL)
  rescue => e
    [false, e.message]
  end
end

loop do
  working, message = internet_connection?
  unless working
    dt = DateTime.now.to_s
    puts "Outage at #{dt}: #{message}"
    CSV.open(LOG_FILE, 'a') { |c| c << [dt, message] }
  end
  sleep SECONDS_BETWEEN_TRIES
end