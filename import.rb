#!/usr/bin/env ruby

require "csv"
require "yelpster"

file = ARGV[0]

abort "Error: Must include CSV file" if file.nil?

Yelp.configure(
   :consumer_key    => '',
   :consumer_secret => '',
   :token           => '',
   :token_secret    => ''
)

# construct a client instance
client = Yelp::Client.new

include Yelp::V2::Search::Request

businesses = CSV.read(file, {})

businesses.each do |row|
  request = Location.new(
              :term => row[0],
              :city => row[1],
              :limit => "1")
  response = client.search(request)

  row << response["businesses"].first["id"]
end

CSV.open("results.csv", "w") do |csv|
  businesses.each do |row|
    csv << row
  end
end
