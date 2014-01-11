# Configus

[![Gem Version](https://badge.fury.io/rb/configus.png)](https://rubygems.org/gems/configus)
[![Build Status](https://travis-ci.org/kaize/configus.png)](https://travis-ci.org/kaize/configus)
[![Dependency Status](https://gemnasium.com/kaize/configus.png)](https://gemnasium.com/kaize/configus)
[![Code Climate](https://codeclimate.com/github/kaize/configus.png)](https://codeclimate.com/github/kaize/configus)
[![Coverage Status](https://coveralls.io/repos/kaize/configus/badge.png?branch=master)](https://coveralls.io/r/kaize/configus)
[![Gem Version](http://stillmaintained.com/kaize/configus.png)](http://stillmaintained.com/kaize/configus)

## Summary

Configus helps you easily manage environment specific settings

## Installing

Add this to your `Gemfile`:

    gem "configus"

## Examples

### Definition

``` ruby
Configus.build :development do # set current environment
  env :production do
    site_name 'Example'
    web do
      domain   'example.com'
      protocol 'https'
      port     80
      uri      -> { "#{protocol}://#{domain}:#{port}" }
    end
    site_uri   -> { web.uri }
    email do
      pop do
        address 'pop.example.com'
        port    110
      end
      smtp do
        address 'smtp.example.com'
        port    25
      end
    end
  end

  env :development, :parent => :production do
    web do
      domain   'localhost'
      protocol 'http'
      port      9292
    end
    email do
      smtp do
        address 'smpt.text.example.com'
      end
    end
  end
end
```

### Usage

    configus.site_name      # => 'Example'
    configus.web.uri        # => 'https://example.com:80'
    configus.site_uri       # => 'https://example.com:80'
    configus.email.pop.port # => 110

### Rails

define your config in `lib/configus.rb`

    Configus.build Rails.env do
      # settings
    end

reload

    # config/environments/development.rb
    ActionDispatch::Reloader.to_prepare do
      load Rails.root.join('lib/configus.rb')
    end

## Similar

* https://github.com/markbates/configatron
* https://github.com/railsjedi/rails_config
