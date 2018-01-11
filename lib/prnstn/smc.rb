module Prnstn
  class SMC

    def initialize(options)

      @options = options
      if options[:smc] == 'twitter'
        Prnstn::SMC_Twitter.new.run!
      elsif options[:smc] == 'gnusocial'
        Prnstn::SMC_GNUSocial.new.run!
      else
        raise
      end
    end

    def check
      if options[:smc] == 'twitter'
        Prnstn::SMC_Twitter.new.run!
      end

      # TODO: gunusocial
    end
  end

  class SMC_GNUSocial

    require 'open-uri'
    require 'json'

    def initialize(*)

    end

    def run!

      fetch_mentions
      # convert_mentions if @last_mentions

    end

    def fetch_mentions
      Prnstn.log('SMC: Receive last 5 mentions from GNUSocial...')
      result = JSON.parse(open(GNUSOCIAL_MENTIONS_ENDPOINT).read)
      @last_mentions = result[0..4]
      # TODO: handle timeout

      # @last_mentions = [{}]
      @last_mentions.each_with_index do |m,i|
        Prnstn.log("--message #{i} #{m['id']} #{m['created_at']}")
      end
    end

      # TODO: fetch mention (as json)
      # via GNUSOCIAL_MENTIONS_ENDPOINT

      # TODO: convert messages (store values in common format)
      # gnusocial values
      #  id
      #  text
      #  created_at "Thu May 11 11:45:42 +0200 2017"
      #  attachments > 0 > url|thumb_url|large_thumb_url
      #  user > screen_name
      #  user > location


  end

  class SMC_Twitter

    require 'open-uri'


    def initialize(*)

    end

    def run!

      if !ENV['CONSUMER_KEY']
        Prnstn.log("No Twitter consumer_key given. Quitting... ".red)
        exit
      end
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
        Prnstn.log('SMC: Successfully authorized by Twitter API...')
      else
        Prnstn.log('Ups, there might be problem with your Twitter API credentials...'.red)
        exit
      end
      true
    end

    def fetch_mentions
      Prnstn.log("SMC: Receive latest #{MESSAGE_QUEUE} mentions from Twitter...")
      @last_mentions = @client.mentions_timeline[0..MESSAGE_QUEUE]
      # TODO: handle timeout

      # @last_mentions = [{}]
      @last_mentions.each_with_index do |m,i|
        Prnstn.log("-- Receiving message #{i} #{m.id} #{m.created_at}".colorize(:color => :white, :background => :light_black))
      end
    end

    def convert_mentions
      Prnstn.log('Comparing retrieved mentions with database...')
      # convert to common message format
      @last_mentions.each do |mention|
        cmp = Message.where(sid: mention.id).first
        if cmp
          Prnstn.log("Searching for ID, found: #{cmp.sid}. Skipping...")
        else
          # convert message (and grab image)
          Prnstn.log("Searching for ID. Its a new message #{mention.id}. Storing in DB...")
          imagepath = ''
          if mention.media[0] && mention.media[0].media_url
            Prnstn.log("Image ref found: #{mention.media[0].media_url}")
            ### TODO: type throws error && mention.media[0].type == "photo"
            imagepath = "#{ASSET_TWITTER_PATH}/#{mention.id}-1.jpg"
            File.open(imagepath, 'wb') do |fo|
              fo.write open(mention.media[0].media_url).read
            end
            Prnstn.log("Image saved as #{mention.id}-1.jpg".blue)
            if File.exist? imagepath
              Prnstn.log("Image is stored".blue)
            else
              Prnstn.log("Image could not be found".red)
            end
          end

          Prnstn.log("Full text: "+mention.full_text)
          Prnstn.log("Text: "+mention.text)


          # twitter tweet_mode=extended is needed to get full 280 chars
          # see https://github.com/sferik/twitter/issues/880
          # tweaked twitter gem v6.2.0, since this feature is not covered
          # here: check if full_text is available
          # remove image link form mention.text. link looks like http://t.co/SRCatB4oqd
          if mention.full_text.present?
            text = mention.full_text
          else
            text = mention.text
          end
          if mention.media[0] &&  mention.media[0].url
            text = text.sub "#{mention.media[0].url}", ''
          end
          if text.present?
            text = text.sub "@INTPRN", ''
          end
          # text = text.gsub(/#{URI::regexp}/, '')

          Prnstn.log("Text found and reduced: #{text}")
          # body = "#{text}\n<<<<<< A message from #{mention.user.screen_name} >>>>>>>\n"
          body = "#{text}\n\n"
          # TODO: set date to the date the message has been created
          message = [
            sid: mention.id,
            title: "m",
            body: body,
            imageurl: imagepath,
            date: Time.now,
            queued: false,
            printed: false
          ]
          Message.create!(message)
          Prnstn.log("New message saved...")
          Prnstn.log("-------------------------")
        end
      end
    end
  end

  class SMC_Statusnet

  end

end