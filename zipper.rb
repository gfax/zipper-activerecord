#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/activerecord'
require 'slim'
require 'uri'

set :database, "sqlite3:///links.sqlite3"

class String

  def uri?
    uri = URI.parse self
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

end


class Zipper < Sinatra::Base

  # URL's are given a base-62 ID to make them as small as possible.
  module Base62

    NUMERALS = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

    def encode(i)
      raise ArgumentError unless Numeric === i
      return '0' if i == 0
      s = ''
      while i > 0
        s << NUMERALS[i.modulo(62)]
        i /= 62
      end
      s.reverse
    end

    def decode(i)
      s = i.to_s.reverse.split('') 
      total = 0
      s.each_with_index do |char, index|
        # Check link for valid chars.
        if ord = NUMERALS.index(char)
          total += ord * (62 ** index)
        else
          return nil
        end
      end
      total.to_s
    end

    module_function :encode, :decode

  end


  module UrlShortener

    class Link < ActiveRecord::Base; end

    def self.shorten(original_url)
      if link = Link.find_by_original(original_url)
        # Return the previously used short url
        # if this url has been shortened before.
        shortened = link.shortened
      else
        # Check the index entry '0' for the next short url to use.
        unless index = Link.find_by_original('0')
          Link.create!(:original => '0', :shortened => '1' )
          index = Link.find_by_original('0')
        end
        shortened = Base62.encode(index.shortened)
        index.shortened = (index.shortened.to_i + 1).to_s
        Link.delete_all(:original => '0')
        Link.create!(:original => index.original, :shortened => index.shortened)
        Link.create!(:original => original_url, :shortened => shortened)
      end
      return shortened
    end

    def self.original(shortened)
      link = Link.find_by_shortened(shortened)
      link.original
    end

  end


  get '/' do
    slim :index
  end

  post '/' do
    http_host = request.env['HTTP_HOST']
    @original_url = params[:url]
    # Make sure @original url is indeed a url.
    if @original_url.uri?
      shortened = UrlShortener.shorten(@original_url)
      @shortened_url = "http://#{http_host}/#{shortened}"
      slim :shortened
    else
      slim :invalid_url
    end
  end

  get '/:shortened' do
    original_url = UrlShortener.original(params[:shortened])
    if original_url.nil?
      redirect '/'
    else
      redirect original_url
    end
  end

end
