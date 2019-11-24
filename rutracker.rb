require_relative 'secret'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

class RuTracker

  def initialize()
    @agent                  = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
    login
  end

  def login()
    login_page = 'https://rutracker.org/forum/login.php'

    @agent.get(login_page) do |page|
      page.form_with(action: 'login.php') do |p|
        p['login_username'] = RUTRACKER_LOGIN
        p['login_password'] = RUTRACKER_PASSWORD
        button              = p.button_with(value: 'вход')
        p.submit(button)
      end
    end


  end

  def find_torrents(search_word)
    full_info   = []
    serach_page = 'https://rutracker.org/forum/tracker.php?nm=' + search_word
    @agent.get(serach_page) do |page|
      page.css('div#search-results > table > tbody > tr').to_a.each do |row|
        torrent_seeds    = row.search('td')[6].search('b').text
        torrent_leechers = row.search('td')[7].text

        if (torrent_seeds && torrent_leechers) != '0'
          torrent_name = row.search('td')[3].search('a').text
          torrent_size = row.search('td')[5].search('a').text[0..-3]
          torrent_link = 'https://rutracker.org/forum/' + row.search('td')[5].search('a')[0]['href']
          full_info << ["S: #{torrent_seeds} L: #{torrent_leechers} Size: #{torrent_size}", torrent_name, torrent_link]
        end
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