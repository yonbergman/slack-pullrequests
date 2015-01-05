require 'octokit'
TOKEN = ENV['GITHUB_TOKEN']
REPOS = ['TheGiftsProject/teacup-server',
         'TheGiftsProject/teacup-native',
         'TheGiftsProject/teacup-peas']

TRANSLATE_USER = {
  'yonbergman' => 'yonbergman',
  'sdavidson' => 'ShayDavidson',
  'benny' => 'gardenofwine',
  'assafgelber' => 'agelber',
  'udi' => 'udiWertheimer',
}

class Client

  attr_reader :client

  def initialize
    @client = Octokit::Client.new(access_token: TOKEN)
  end

  def need_work(for_user)
    github_user = TRANSLATE_USER[for_user]

    output = []
    all_pull_requests.map do |repo, pull_requests|
      pull_requests.reject! { |pull| pull[:user] == github_user }
      pull_requests.reject! { |pull| pull[:reviewers].include? github_user }
      unless pull_requests.empty?
        content = ["----- #{repo} -----"]
        content += pull_requests.map {|pull|
          [
            "#{pull[:name]} by #{pull[:user]} - #{pull[:labels].join(", ")}",
            pull[:url]
          ]
        }.flatten
        output << content.join("\n")
      end
    end
    output.join("\n\n")
  end

  def all_pull_requests
    Hash[
      REPOS.map do |repo_name|
        [repo_name, for_repo(repo_name)]
      end
    ]
  end

  def for_repo(name)
    all_pulls = @client.pulls(name)
    all_pulls.map { |pull|
      {
        name: pull.title,
        url: pull.html_url,
        user: pull.user.login,
        labels: labels(pull),
        reviewers: for_pull_requests(pull) - [pull.user.login],
      }
    }
  end

  def for_pull_requests(pull)
    all_comments = pull.rels['comments'].get.data
    users = all_comments.map {|comment| comment.user.login }.uniq
  end

  def labels(pull)
    pull.rels['issue'].get.data.labels.map(&:name)
  end

end
