require './secret.rb'
require 'telegram/bot'

def rutor
  nil
end

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|

    buttons = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(Rutor Empty_1), %w(Empty_2 Искать_везде)], resize_keyboard: true)

    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: 'Выберите трекер для поиска:', reply_markup: buttons)
    when 'Rutor'
      bot.api.send_message(chat_id: message.chat.id, text: rutor)
    else
      nil
    end
  end
end
