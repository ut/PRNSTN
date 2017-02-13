require 'spec_helper'

describe Prnstn::Main do
  it 'has a version number' do
    expect(Prnstn::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(false)
  end


  it 'stops without token provided' do

    options = {}
    pnr = Prnstn::Main.new(options)
    expect(pnr.prepare).to be == "No token provided. Quitting...!"

  end

  it 'sends a message to logger' do
    options = {}
    logger = Prnstn::Logger.new('log/prnstn.log')
    expect(logger.log("hey")).to be == 33
  end

  it "check default CLI options" do
      options = {}
      pnr = Prnstn::Main.new(options)
      expect(pnr.options[:instant_print]).to be true
  end

  it "check value swap for instant_print option" do
      options = {:onpush_print => true}
      pnr = Prnstn::Main.new(options)
      expect(pnr.options[:instant_print]).to be nil
  end

  ### TODO: test logger

end