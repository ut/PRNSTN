# Prnstn

Script to handle a printer and feed it w/social media content

This program is under development, see TODO for a list of open tasks and features

## Prerequisites

Ruby 2.x, Rubygems

```bash
$ sudo apt-get install libcups2 libcups2-dev
```

## Installation

```bash
  $ bundle install
```
Create a Twitter application via https://apps.twitter.com/ and export the following credentials into your local environment:

```bash
  $ export CONSUMER_KEY="..."
  $ export CONSUMER_SECRET="..."
  $ export ACCESS_TOKEN="..."
  $ export ACCESS_TOKEN_SECRET="..."
```

## Usage

```bash
  $ REMOTE_TOKEN=xxxx bin/prnstn
```

## Development

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ut/prnstn. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Credits & License

A project by Ulf Treger <ulf.treger@googlemail.com>

Running via CLI and as a daemonized script based on a concept by Jake Gordon at [Daemonizing Ruby Processes](http://codeincomplete.com/posts/ruby-daemons/)

This project is licensed under a [GNU General Public Licence v3](LICENSE.txt).

