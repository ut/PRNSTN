# Prnstn

Script to handle a printer and feed it w/social media content from any linux computer.

This program is under development, not ready for producive use. See TODO for a (incomplete) list of open tasks and features

See [INTPRN](https://ut.github.io/INTPRN/) for more informations about the project, this software is part of.

Tested with Ubuntu 16.04 and Raspian 4.1 (for Raspberry Pi)

## Prerequisites

Ruby 2.x, Rubygems, CUPS 2.1.3, wiringpi, Rspec 3.5.0, ActiveRecord, SQLite

## Installation

Install CUPS

```bash
$ sudo apt-get install libcups2 libcups2-dev
```

You'll need a printer installed, at least and if you want print to file install CUPS-PDF


```bash
$ sudo apt-get install cups-pdf
```

(The files will saved at /home/USER/PDF )

Install the needed gems:

```bash
  $ bundle install
```

### Setup a social media plattform

To communicate with the Internet printer, it needs its own social media channel. You can either setup a GNU Social or Twitter account. Other platforms may be included in the future (you are welcome to contribute to this project by adding your favorite platform).

### GNU Social

Create a profile at your favorite GNU Social installation. Check the sourcecode of the profile page or ask the admins for your ID and the API URL.

Edit lib/prnstn/config.rb:

```bash
  GNUSOCIAL_ID = ''
  GNUSOCIAL_MENTIONS_ENDPOINT  = 'https://your.gnusocial.installation/api/statuses/mentions/'+GNUSOCIAL_ID+'.json'

```

### Twitter

Create a Twitter application via [apps.twitter.com](https://apps.twitter.com/) and export the following credentials into your local environment:

```bash
  $ export CONSUMER_KEY="..."
  $ export CONSUMER_SECRET="..."
  $ export ACCESS_TOKEN="..."
  $ export ACCESS_TOKEN_SECRET="..."
```

## Usage

```bash
  $ ./bin/prnstn
```

Per default, the PRNTSTN runs in dry mode (without printing anything).

Show all parameters:

```bash
  $ ./bin/prnstn  -h
```



### Raspberry Pi

On Raspberry Pi, an external button can be used to print latest messages. See [INTPRN](https://ut.github.io/INTPRN/) for the hardware needed.

Since we use Raspberry Pi GPIO for that, we need to run this script as root!

## Development

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ut/prnstn. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Credits & License

A project by Ulf Treger <ulf.treger@googlemail.com>

Running via CLI and as a daemonized script based on a concept by Jake Gordon at [Daemonizing Ruby Processes](http://codeincomplete.com/posts/ruby-daemons/)

This project is licensed under a [GNU General Public Licence v3](LICENSE.txt).

