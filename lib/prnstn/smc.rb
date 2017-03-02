module Prnstn
  class SMC

    def initialize
      if SMC_PLATTFORM == 'twitter'
        Prnstn::SMC_Twitter.new.run!
      end

    end

    def check
      if SMC_PLATTFORM == 'twitter'
        Prnstn::SMC_Twitter.new.run!
      end
    end
  end

  class SMC_Twitter

    require "open-uri"


    def initialize(*)

    end

    def run!
      fetch_mentions if auth
      convert_mentions if @last_mentions
    end

    def auth
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY']
        config.consumer_secret     = ENV['CONSUMER_SECRET']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end
      if @client
        Prnstn.log('Successfully authorized by Twitter API...')
      else
        Prnstn.log('Ups, there might be problem with your Twitter API credentials...')
      end
      true
    end

    def fetch_mentions
      Prnstn.log('Got last 5 mentions from Twitter...')
      @last_mentions = @client.mentions_timeline[0..4]
      # TODO: handle timeout

      # @last_mentions = [{}]
      @last_mentions.each_with_index do |m,i|
        Prnstn.log("--message #{i} #{m.id} #{m.created_at}")
      end
    end

    def convert_mentions
      Prnstn.log('TODO: Storing mentions into database...')
      # convert to common message format
      @last_mentions.each do |mention|
        cmp = Message.where(sid: mention.id).first
        if cmp
          # skip conversion if message is already known
          Prnstn.log("Search for message ID. Found  #{cmp.sid}")
        else
          # convert message (and grab image)
          Prnstn.log("Search for message ID. Its a new message #{mention.id}")

          # grab and store first image
          if mention.media[0]
            ### TODO: type throws error:
                  # && mention.media[0].type == "photo"
            File.open("#{ASSET_TWITTER_PATH}/#{mention.id}-1.jpg", 'wb') do |fo|
              fo.write open(mention.media[0].media_url).read
            end
            Prnstn.log("Image saved!")

          end
          # remove image link form mention.text. link looks like http://t.co/SRCatB4oqd
          text = mention.text.sub "#{mention.media[0].url}", '++++++'
          body = "#{text}\n<<<<<< A message from #{mention.user.screen_name} >>>>>>>\n"
          message = [
            sid: mention.id,
            title: "m",
            body: body,
            imageurl: "#{ASSET_TWITTER_PATH}/#{mention.id}-1.jpg",
            date: Time.now,
            queued: false,
            printed: false
          ]
          Message.create!(message)
          Prnstn.log("Search for message ID. New message saved!")
        end

      end

    end

  end

  class SMC_Statusnet

  end

end