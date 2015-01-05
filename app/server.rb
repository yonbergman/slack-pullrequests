require 'sinatra'
require_relative './client'

SLACK_TOKEN = ENV['SLACK_TOKEN']

class SlackServer < Sinatra::Base

  post '/webhook' do
    return 401 unless request["token"] == SLACK_TOKEN

    user = request['user_name']
    text = Client.new.need_work(user)
    text = 'You have no pull requests to go over :D' if text.empty?
    text
  end
end
