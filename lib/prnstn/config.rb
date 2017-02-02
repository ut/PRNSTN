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
end
