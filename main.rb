require './secret.rb'
require 'telegram/bot'
require_relative 'rutor'




Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|

    buttons = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(Rutor Empty_1), %w(Empty_2 Искать_везде)], resize_keyboard: true)

    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: 'Введите что хотите найти:')
      # bot.api.send_message(chat_id: message.chat.id, text: 'Выберите трекер для поиска:', reply_markup: buttons)
    else
      bot.api.send_message(chat_id: message.chat.id, text: Rutor.find(message.text))
      # bot.api.send_message(chat_id: message.chat.id, text: 'Rutor.find(message.text)')
    end
  end
end
