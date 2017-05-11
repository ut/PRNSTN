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
  SMC_PLATTFORMS = ['twitter','gnusocial']

  SMC_PLATTFORM = 'gnusocial'

  # twitter api
  CONSUMER_KEY = ENV['CONSUMER_KEY']
  CONSUMER_SECRET = ENV['CONSUMER_SECRET']
  ACCESS_TOKEN = ENV['ACCESS_TOKEN']
  ACCESS_TOKEN_SECRET = ENV['ACCESS_TOKEN_SECRET']

  # gnusocial api, https://gnusocial.net/doc/twitterapi
  # "User nicknames are unique, but they are not globally unique. Use the ID number instead."

  GNUSOCIAL_ID = '1829'
  GNUSOCIAL_MENTIONS_ENDPOINT  = 'https://schnackr.hamburg.freifunk.net/api/statuses/mentions/'+GNUSOCIAL_ID+'.json'






  # manually set the machine name (aka HOST aka COMPUTER)
  if ENV['MACHINE']
    MACHINE = ENV['MACHINE']
  elsif
    MACHINE = "#{ENV['_system_name']} #{ENV['_system_version']}"
  else
    MACHINE = 'unknown'
  end

  # SMC specific
  ASSET_TWITTER_PATH = 'system/twitter'

  require 'fileutils'

  dirname = File.dirname(ASSET_TWITTER_PATH)
  unless File.directory?(ASSET_TWITTER_PATH)
    FileUtils.mkdir_p(ASSET_TWITTER_PATH)
  end

end
