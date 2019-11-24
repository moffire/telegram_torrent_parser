require 'nokogiri'
require 'open-uri'

class Rutor

  def self.find_torrents(search_word)
    full_info  = []
    link       = "http://new-rutor.org/search/#{URI.encode(search_word)}/"
    html       = open(link).read
    doc        = Nokogiri::HTML.parse(html, encoding = 'utf-8')
    table_rows = doc.css('div#index table tr')

    table_rows.drop(1).each do |row|
      torrent_seeds    = row.css('td[align="center"] span.green').text[1..-1] #remove invisible space
      torrent_leechers = row.css('td[align="center"] span.red').text[1..-1] #remove invisible space

      if (torrent_seeds && torrent_leechers) != '0'
        begin
          torrent_name = row.css('td a')[1].text
          torrent_link = 'new-rutor.org' + row.css('td a')[0]['href']
        rescue NoMethodError
          torrent_name = row.css('td a')[0].text
          torrent_link = "Ссылка не торрент отсутствует"
        end

        torrent_size = row.css('td[align="right"]')[1].text
        full_info << ["S: #{torrent_seeds} L: #{torrent_leechers} Size: #{torrent_size}", torrent_name, torrent_link]
      end

    end

    # format text in separate lines and return limited numbers of lines in order to avoid Error 400: message is too long
    if full_info.empty?
      nil
    else
      full_info.each_slice(10).map { |element| element.map { |a, s, d| [a, s, "[\xE2\xAC\x87 Скачать](#{d})\n"] } * "\n" }
    end

  end

end