# frozen_string_literal: true

token = ENV['TELEGRAM_TOKEN']

module PdfUploader
  class Bot
    COMMANDS = { '/start' => 'Start the bot', '/upload_url' => 'Upload url to get files from resource',
                 '/help' => 'Print all commands' }.freeze

    def initialize(token:)
      @token = token
    end

    def start!
      Telegram::Bot::Client.run(@token, logger: Logger.new($stderr)) do |bot|
        bot.logger.info('Bot has been started')
        bot.listen do |message|
          case message.text
          when '/start'
            bot.api.send_message(chat_id: message.chat.id,
                                 text: "Hello, #{message.from.first_name}, give me url of \"Index of\" page an I'll" \
                                        'send you all PDF files here for immediate access.')
          when '/upload_url'
            bot.api.send_message(chat_id: message.chat.id,
                                 text: 'Please, provide me an "Index of" url.')
            receive_url(bot)
          when '/help'
            bot.api.send_message(chat_id: message.chat.id, text: "My commands are:\n#{commands}")
          else
            bot.api.send_message(chat_id: message.chat.id,
                                 text: "Sorry, I don't understand. You can find my commands via /help.")
          end
        end
      end
    end

    private

    def receive_url(bot)
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          text = PdfUploader::URL.new(message.text).update_url!
          if text.url?
            (links = PdfUploader::Parser.parse!(text)).first.each do |uri|
              bot.api.send_message(chat_id: message.chat.id, text: uri)
            end
            bot.api.send_message(chat_id: message.chat.id,
                                 text: "Links found: #{links.last}\nLinks filtered: #{filtered(links)} " \
                                 "(#{links.first.size} uploaded)")
          else
            bot.api.send_message(chat_id: message.chat.id, text: 'Invalid url')
          end
        end
        break
      end
    end

    def filtered(links)
      links.last - links.first.size
    rescue NoMethodError
      'Invalid url or no links were found.'
    end

    def commands
      @commands ||= COMMANDS.each_with_object('') do |(k, v), obj|
        obj << "#{k}: #{v}\n"
      end
    end
  end
end

bot = PdfUploader::Bot.new(token: token)
bot.start!
