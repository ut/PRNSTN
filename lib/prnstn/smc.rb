module Prnstn
  class SMC

    def initialize
      if SMC_PLATTFORM == 'twitter'
        Prnstn::SMC_Twitter.new
      end

    end

  end

  class SMC_Twitter

    def initialize
      fetch_mentions if auth
    end

    def auth
      # @client = Twitter::REST::Client.new do |config|
      #   config.consumer_key        = ''
      #   config.consumer_secret     = ''
      #   config.access_token        = ''
      #   config.access_token_secret = ''
      # end
      Prnstn.log('Successfully autherized by Twitter API...')
      true
    end

    def fetch_mentions
      # @last_mentions = @client.mentions_timeline[0]
      Prnstn.log('Got last mentions from Twitter...')
      @last_mentions = [{}]
    end

  end

  class SMS_Statusnet

  end

end