require './secret.rb'
require 'telegram/bot'
require_relative 'rutor'


Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|

    #create buttons
    buttons      = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyborad: [%w(Rutor Empty_1), %w(Empty_2 Искать_везде)], resize_keyboard: true, one_time_keyboard: true)
    start_button = message.text

    case start_button
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: 'Выберите трекер для поиска:', reply_markup: buttons)

    when 'Rutor'
      bot.api.send_message(chat_id: message.chat.id, text: 'Введите что искать:')

      while true
        bot.listen do |search_param|
          if search_param.text == 'back'
            status = false
          else
            bot.api.send_message(chat_id: message.chat.id, text: Rutor.find(search_param.text))
          end
        end
      end

    end
  end
end