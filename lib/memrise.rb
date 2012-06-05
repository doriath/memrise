require "memrise/version"
require 'memrise/user'
require 'memrise/iset'
require 'memrise/item'
require 'json'

class Memrise
  def initialize(fetcher)
    @fetcher = fetcher
  end

  # If user with specified name exists, it returns it; otherwise returns nil
  def find_user(username)
    body = @fetcher.fetch("http://www.memrise.com/api/1.0/user/?format=json&username=#{username}")
    json = JSON.parse(body)

    return nil if json["objects"].empty?

    User.new.tap do |user|
      user.id = json["objects"][0]["id"]
      user.username = json["objects"][0]["username"]
    end
  end

  def find_iset(slug)
    body = @fetcher.fetch("http://www.memrise.com/api/1.0/iset/?format=json&slug=#{slug}")
    json = JSON.parse(body)

    return nil if json["objects"].empty?

    Iset.new.tap do |iset|
      iset.id = json["objects"][0]["id"]
    end
  end

  def get_items_for(iset_id)
    body = @fetcher.fetch("http://www.memrise.com/api/1.0/itemiset/?format=json&iset=#{iset_id}")
    json = JSON.parse(body)

    json["objects"].map do |object|
      Item.new.tap do |item|
        item.word = object["word"]
        item.definition = object["definition"]
      end
    end
  end
end
