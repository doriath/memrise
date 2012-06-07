require 'open-uri'

class Fetcher
  def fetch(url)
    open(url).read
  end
end
