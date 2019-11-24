require_relative 'secret'
require 'telegram/bot'
require_relative 'rutor'
require_relative 'rutracker'

search_param = ''

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|

    buttons  = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Rutor', callback_data: 'rutor'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'RuTracker', callback_data: 'rutracker'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Empty_2', callback_data: 'empty_2')
    ]
    keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)

    if message.is_a?(Telegram::Bot::Types::Message)
      case message.text

      when '/start'
        bot.api.send_message(chat_id: message.from.id, text: 'Введите что искать:')
      else
        search_param = message.text
        bot.api.send_message(chat_id: message.chat.id, text: 'Где искать:', reply_markup: keyboard)
      end

    elsif message.is_a?(Telegram::Bot::Types::CallbackQuery)
      case message.data

      when 'rutor'
        full_found_list = Rutor.find_torrents(search_param)
        if full_found_list.nil?
          bot.api.send_message(chat_id: message.from.id, text: 'Ничего не найдено. Попробуйте другой трекер.')
        else
          full_found_list.each do |splitted_answer|
            bot.api.send_message(chat_id: message.from.id, text: splitted_answer, parse_mode: 'Markdown')
          end
        end

      when 'rutracker'
        full_found_list = RuTracker.new.find_torrents('korn')
        if full_found_list.nil?
          bot.api.send_message(chat_id: message.from.id, text: 'Ничего не найдено. Попробуйте другой трекер.')
        else
          full_found_list.each do |splitted_answer|
            bot.api.send_message(chat_id: message.from.id, text: splitted_answer, parse_mode: 'Markdown')
          end
        end
      end

    end
  end
end
