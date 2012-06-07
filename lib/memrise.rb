require "memrise/version"
require 'memrise/user'
require 'memrise/iset'
require 'memrise/item'
require 'memrise/fetcher'
require 'json'

class Memrise
  def initialize(fetcher = Fetcher.new)
    @fetcher = fetcher
  end

  # If user with specified name exists, it returns it; otherwise returns nil
  def find_user(username)
    objects = fetch_objects '/api/1.0/user/', username: username

    objects.map do |object|
      User.new.tap do |user|
        user.id = object["id"]
        user.username = object["username"]
      end
    end.first
  end

  def find_iset(slug)
    objects = fetch_objects '/api/1.0/iset/', slug: slug

    objects.map do |object|
      Iset.new.tap do |iset|
        iset.id = object["id"]
      end
    end.first
  end

  def get_items_for(iset_id)
    objects = fetch_objects '/api/1.0/itemiset/', iset: iset_id

    objects.map do |object|
      Item.new.tap do |item|
        item.word = object["item"]["word"]
        item.definition = object["item"]["defn"]
      end
    end
  end

  private

  def fetch_objects resource_uri, options
    options = {format: 'json'}.merge(options)
    url = "http://www.memrise.com" + resource_uri + "?" + parameterize(options)

    json = JSON.parse(@fetcher.fetch(url))
    unless json['meta']['next'].nil?
      options = {format: 'json', limit: json['meta']['total_count']}.merge(options)
      url = "http://www.memrise.com" + resource_uri + "?" + parameterize(options)
      json = JSON.parse(@fetcher.fetch(url))
    end

    json['objects']
  end

  def parameterize(params)
    URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
  end
end
