require 'nokogiri'
require 'open-uri'

class Rutor

  def self.find(search_word)
    full_info  = []
    link       = "http://new-rutor.org/search/#{search_word}/"
    html       = open(link)
    doc        = Nokogiri::HTML.parse(html, encoding = 'utf-8')
    table_rows = doc.css('div#index table tr')
    table_rows.drop(1).each do |row|
      torrent_name     = row.css('td a')[1].text
      torrent_link     = 'new-rutor.org' + row.css('td a')[0]['href']
      torrent_size     = row.css('td[align="right"]')[1].text
      torrent_seeds    = row.css('td[align="center"] span.green').text[1..-1] #remove invisible space
      torrent_leechers = row.css('td[align="center"] span.red').text[1..-1] #remove invisible space
      if (torrent_seeds && torrent_leechers) != '0'
        full_info << ["S: #{torrent_seeds} L: #{torrent_leechers} Size: #{torrent_size}", torrent_name, torrent_link]
      end
    end
    # format text in separat lines
    if full_info.empty?
      "Nothing found(("
    else
      full_info.map { |a, s, d| [a, s, ["#{d}\n"]] } * "\n"
    end
  end
end