# frozen_string_literal: true

class ParseLink
  include Sidekiq::Worker

  def perform(bot, message, text)
    (links = PdfUploader::Parser.parse!(text)).first.compact.each do |uri|
      bot.api.send_message(chat_id: message.chat.id, text: uri)
    end
    bot.api.send_message(chat_id: message.chat.id,
                         text: "Links found: #{links[1]}\nLinks filtered: #{filtered(links)} " \
                                 "(#{links.first.size} uploaded)")
  end
end
