require 'nokogiri'
require 'open-uri'

class Rutor

  def self.find(search_word)
    links = {}
    link = "http://new-rutor.org/search/#{search_word}/"
    html = open(link)
    doc  = Nokogiri::HTML.parse(html, encoding = 'utf-8')
    table_rows = doc.css('div#index table tr')
    table_rows.drop(1).each do |row|
      torrent_link = row.css('td a')[0]['href']
      puts torrent_link
    end
  end

end

Rutor.find('office')