# Configus

## Summary

Configus helps you easily manage environment specific settings

[![Build Status](https://secure.travis-ci.org/mokevnin/configus.png)](http://travis-ci.org/mokevnin/configus)

## Installing

Add this to your `Gemfile`:

    gem "configus"

## Examples

### Definition

    Configus.build :development do # set current environment
      env :production do
        website_url 'http://example.com'
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
        website_url 'http://text.example.com'
        email do
          smtp do
            address 'smpt.text.example.com'
          end
        end
      end
    end

### Usage

    configus.website_url # => 'http://text.example.com'
    configus.email.pop.port # => 110

### Rails

define your config in `lib/configus.rb`

    Configus.build Rails.env do
      # settigns
    end

reload
    
    # config/environments/development.rb
    ActionDispatch::Reloader.to_prepare do
      load Rails.root.join('lib/configus.rb')
    end

## Similar

* https://github.com/markbates/configatron
* https://github.com/railsjedi/rails_config
