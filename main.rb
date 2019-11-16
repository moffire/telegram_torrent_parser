require './secret.rb'
require 'telegram/bot'
require_relative 'rutor'


Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|

    case message

    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        buttons  = [
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Rutor', callback_data: 'rutor'),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Empty_1', callback_data: 'empty_1'),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Empty_2', callback_data: 'empty_2')
        ]
        keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)
        bot.api.send_message(chat_id: message.chat.id, text: 'Где искать:', reply_markup: keyboard)
      end

    when Telegram::Bot::Types::CallbackQuery
      bot.api.send_message(chat_id: message.from.id, text: 'Введите что искать:')
      search_param = #??????????
      case message.data
      when 'rutor'
        bot.api.send_message(chat_id: message.from.id, text: Rutor.find(search_param))
      end
    end
  end
end