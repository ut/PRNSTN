module Prnstn
  NAME = 'PRNSTN'
  # defaults
  PRINT_MODE = 'all' # options: all|friends|self
  MESSAGE_QUEUE = 5
  MESSAGE_LIFETIME = '1w' # format?

  # configuration of the remote host (control/monitoring instance)
  REMOTE_HOST = ''
  REMOTE_PORT = ''
  REMOTE_TOKEN = ENV['REMOTE_TOKEN']

  # configuration of the used social media plattform
  SMC_PLATTFORM = 'twitter'
  CONSUMER_KEY = ENV['CONSUMER_KEY']
  CONSUMER_SECRET = ENV['CONSUMER_SECRET']
  ACCESS_TOKEN = ENV['ACCESS_TOKEN']
  ACCESS_TOKEN_SECRET = ENV['ACCESS_TOKEN_SECRET']



  # SMC specific
  ASSET_TWITTER_PATH = 'system/twitter'

  require 'fileutils'

  dirname = File.dirname(ASSET_TWITTER_PATH)
  unless File.directory?(ASSET_TWITTER_PATH)
    FileUtils.mkdir_p(ASSET_TWITTER_PATH)
  end

end
