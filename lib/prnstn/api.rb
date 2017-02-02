# TODO: send a status msg via json/rest
# require 'net/http'
# require 'uri'
# require 'json'

# TODO: create some helper routines
# Logging (to file)
# ErrorRoutine/Exception notifier -> EMAIL

# TODO: setup vars
t = 'token'
m = 'msg'
# TODO: initiate communication

# TODO: auth

# TODO: send message
# url might be like that: https://#{Prnstn::CTRLSTN}/api/send/?t=#{t}&m=#{msg}
# response code
# response = Net::HTTP.get_response(Settings.host, '#{url}?#{params_string}')
# result = JSON.parse(response.body)

# LOG.debug 'BODY: #{response.body}'
# return false if response.body == 'false'
# return true if response.body == 'true'
