module Prnstn
  NAME = 'PRNSTN'
  # defaults
  PRINT_MODE = 'all' # options: all|friends|self
  MESSAGE_QUEUE = 20.freeze
  MESSAGE_LIFETIME = '1w'.freeze # format?
  INSTANT_PRINT_INTERVAL = 200.freeze


  # manually set the machine name (aka HOST system)
  if ENV['MACHINE']
    MACHINE = ENV['MACHINE'].freeze
  elsif !ENV['_system_name'].nil?
    MACHINE = "#{ENV['_system_name']} #{ENV['_system_version']}".freeze

  else
    MACHINE = 'an unnamend machine (use ENV[\'machine\'] to name it)'.freeze
  end


  # configuration of the remote host (control/monitoring instance) (TODO)
  # REMOTE_HOST = ''
  # REMOTE_PORT = ''
  REMOTE_TOKEN = ENV['REMOTE_TOKEN']

  # configuration of the used social media plattform
  SMC_AVAILABLE_PLATTFORMS =  %w[twitter gnusocial]
  SMC_PLATTFORM = 'twitter'

  # twitter api
  CONSUMER_KEY = ENV['CONSUMER_KEY']
  CONSUMER_SECRET = ENV['CONSUMER_SECRET']
  ACCESS_TOKEN = ENV['ACCESS_TOKEN']
  ACCESS_TOKEN_SECRET = ENV['ACCESS_TOKEN_SECRET']

  # gnusocial api, https://gnusocial.net/doc/twitterapi
  # "User nicknames are unique, but they are not globally unique. Use the ID number instead."
  GNUSOCIAL_ID = '1829'.freeze
  GNUSOCIAL_MENTIONS_ENDPOINT  = 'https://schnackr.hamburg.freifunk.net/api/statuses/mentions/'+GNUSOCIAL_ID+'.json'.freeze

  # SMC specific
  ASSET_TWITTER_PATH = "twitter/"
end