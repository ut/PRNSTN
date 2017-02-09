module Prnstn
  class SMC

    def initialize
      if SMC_PLATTFORM == 'twitter'
        Prnstn::SMC_Twitter.new.run!
      end

    end

  end

  class SMC_Twitter

    def initialize(*)

    end

    def run!
      fetch_mentions if auth
      convert_mentions if @last_mentions
    end

    def auth
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        =  ENV['CONSUMER_KEY']
        config.consumer_secret     = ENV['CONSUMER_SECRET']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end
      if @client
        Prnstn.log('Successfully autherized by Twitter API...')
      else
        Prnstn.log('Ups, there might be problem with your Twitter API credentials...')

      end
      true
    end

    def fetch_mentions
      Prnstn.log('Got last 5 mentions from Twitter...')
      @last_mentions = @client.mentions_timeline[0..4]

      # @last_mentions = [{}]
      @last_mentions.each_with_index do |m,i|
        Prnstn.log("--message #{i} #{m.id} #{m.created_at}")
      end
    end

    def convert_mentions
      Prnstn.log('TODO: Storing mentions into database...')
      # TODO: convert to the common message format
      # we need: SID, title, body, imageurl, date
    end

  end

  class SMC_Statusnet

  end

end