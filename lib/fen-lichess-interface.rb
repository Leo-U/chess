require 'net/http'
require 'uri'
require 'json'
require 'launchy'

fen = "5n1b/8/4k3/8/8/3K4/5NQ1/8 w - - 0 1"  # Replace this with your desired FEN
api_token = "lip_FNJcC9442Q9v6zi6kzw1"  # Replace this with your Lichess API token

pgn = "[FEN \"#{fen}\"]\n\n*"

url = URI("https://lichess.org/api/import")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Authorization"] = "Bearer #{api_token}"
request.set_form_data({ "pgn" => pgn })

response = http.request(request)

if response.code == "200"
  puts "Board created successfully!"
  game_data = JSON.parse(response.body)
  game_id = game_data["id"]
  game_url = "https://lichess.org/#{game_id}"
  puts "You can view the game at: #{game_url}"
else
  puts "Error creating board: #{response.body}"
end



url = 'https://www.wikipedia.org'

Capybara.current_driver = :selenium_chrome # or :selenium_firefox, depending on your web browser
Capybara.app_host = url

module MyCapybaraApp
  class << self
    include Capybara::DSL
  end
end

MyCapybaraApp.visit('/')
MyCapybaraApp.click_link('Link Text') # replace with the actual link text or selector for the link that redirects to the new URL
