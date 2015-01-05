require 'ostruct'

$config = OpenStruct.new(
  github_token: ENV['GITHUB_TOKEN'],
  repos: ENV['GITHUB_REPOS'].split(/\s/),
  users: {
    'yonbergman' => 'yonbergman',
    'sdavidson' => 'ShayDavidson',
    'benny' => 'gardenofwine',
    'assafgelber' => 'agelber',
    'udi' => 'udiWertheimer',
  }
)
