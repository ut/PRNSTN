[![Maintainability](https://api.codeclimate.com/v1/badges/fe912f77779b32b49d84/maintainability)](https://codeclimate.com/github/ut/PRNSTN/maintainability) [![Dependency Status](https://beta.gemnasium.com/badges/github.com/ut/PRNSTN.svg)](https://beta.gemnasium.com/projects/github.com/ut/PRNSTN)

# Prnstn

Script to handle a printer and feed it w/social media content from any linux computer.

This program is under development, not ready for producive use. See TODO for a (incomplete) list of open tasks and features

See [INTPRN](https://ut.github.io/INTPRN/) for more informations about the project, this software is part of.

Tested with Ubuntu 16.04 and Raspian 4.1 + Raspian 4.9 (for Raspberry Pi)

## Prerequisites

Ruby 2.x, Rubygems, CUPS 2.1.3, Wiringpi (Binding for gpio), Rubgems, Rake, Rspec 3.5.0, ActiveRecord, SQLite3, GIT

Raspian 4.9 has Ruby 2.3 and gpio 2.44 

## Installation

Install CUPS

```bash
$ sudo apt-get install libcups2 libcups2-dev
```

You'll need a printer installed, at least install CUPS-PDF to have a print-to-file option:

```bash
$ sudo apt-get install cups-pdf
```
(The files will saved at /home/your-username/PDF )

Install Wiringpi (only needed if you want install an external button, see below). See [Wiringpi.com](http://wiringpi.com/download-and-install/) for detailed instruction

Install Bundler
```bash
  $ sudo gem install bundler
```

Get PRNTSTN code via Github (read-only)

```bash
  $ git clone https://github.com/ut/PRNSTN.git
```

Install the needed gems with Bundler:

```bash
  $ cd PRNSTN
  $ bundle install
```

If you have trouble for the native extension FFI and get a message like...

```bash
  An error occurred while installing ffi (1.9.14), and Bundler cannot continue.
````
...install ruby-dev and then try to install ffi again

```bash
 $ sudo apt-get install ruby-dev
 $ sudo gem install ffi -v '1.9.14'
```

If you have trouble installing the native extension Rainbow and get a message like

```bash
  An error occurred while installing rainbow (2.2.2), and Bundler cannot continue.
```
...install rake and then try to install rainbow again

```bash
 $ sudo gem install rake
 $ sudo gem install ffi -v '1.9.14'
```

If you have trouble installing the native extension SQLite3 and get a message like

```bash
  An error occurred while installing sqlite3 (1.3.12), and Bundler cannot continue.
```
...install libsqlite3-dev and then try to install SQLite3 again

```bash
 $ sudo apt-get install libsqlite3-dev
 $ sudo gem install  sqlite3 -v '1.3.12'
```

### Setup a social media plattform

To communicate with the Internet printer, it needs its own social media channel. You can either setup a GNU Social or Twitter account. Other platforms may be included in the future (you are welcome to contribute to this project by adding your favorite platform).

### GNU Social

Create a profile at your favorite GNU Social installation. Check the sourcecode of the profile page or ask the admins for your ID and the API URL.

Edit lib/prnstn/config.rb:

```bash
  GNUSOCIAL_ID = '...'
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

