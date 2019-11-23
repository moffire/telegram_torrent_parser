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
    login_page  = 'https://rutracker.org/forum/login.php'

    @agent.get(login_page) do |page|
      page.form_with(action: 'login.php') do |p|
        p['login_username'] = RUTRACKER_LOGIN
        p['login_password'] = RUTRACKER_PASSWORD
        button = p.button_with(value: 'вход')
        p.submit(button)
      end
    end


  end

  def find_torrents(search_word)
    serach_page = 'https://rutracker.org/forum/tracker.php'
    @agent.get(serach_page) do |page|
      page.form_with(id: 'quick-search') do |p|
        p['search-text'] = search_word
        search_button = p.button_with(value: 'поиск')
        p.submit(search_button)
      end
    end
  end


end

a = RuTracker.new.find_torrents('korn')
puts a.title