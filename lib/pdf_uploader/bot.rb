# frozen_string_literal: false

token = ENV['TELEGRAM_TOKEN']

module PdfUploader
  # +PdfUploader::Bot+ is a class representing Telegram chat bot.
  class Bot
    # A +PdfUploader::Bot::COMMANDS+ constant stores commands and there description.
    COMMANDS = { '/start' => 'Start the bot', '/upload_url' => 'Upload url to get files from resource',
                 '/help' => 'Print all commands' }.freeze

    # +PdfUploader::Bot.new+                          -> value
    #
    # @param [String] token Token to communicate with Telegram API.
    # @return [Object]
    def initialize(token:)
      @token = token
    end

    # +PdfUploader::Bot#start!+                       -> value
    #
    # This method initializes the work of the bot.
    #
    # @return [Object]
    def start!
      Telegram::Bot::Client.run(@token, logger: Logger.new($stderr)) do |bot|
        bot.logger.info('Bot has been started')
        bot.listen do |message|
          return unless message.is_a?(Telegram::Bot::Types::Message)
          bot.logger.info(message)
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
                                 text: "Sorry, I don't understand. You can find my commands via /help.\nNote: this bot can scrawl only open directories ('Index of') and nothing else! Be patient while uploading content here.")
          end
        end
      end
    end

    private

    # +PdfUploader::Bot#receive_url(bot)+             -> value
    #
    # This method is a backend for +/upload_url+ command.
    #
    # @private
    # @param [PdfUploader::Bot] bot Bot object.
    # @return [Object]
    def receive_url(bot)
      bot.listen do |message|
        text = PdfUploader::URL.new(message.text).update_url!
        if text.url?
          (links = PdfUploader::Parser.parse!(text)).first.compact.each do |uri|
            bot.api.send_message(chat_id: message.chat.id, text: uri)
          end
          bot.api.send_message(chat_id: message.chat.id,
                               text: "Links found: #{links[1]}\nLinks filtered: #{filtered(links)} " \
                                 "(#{links.first.size} uploaded)")
        else
          bot.api.send_message(chat_id: message.chat.id, text: 'Invalid url.')
        end
        break
      rescue NoMethodError, NotImplementedError => e
        bot.logger.error(e)
        bot.logger.error { "Invalid url: #{message.text}" }
        bot.api.send_message(chat_id: message.chat.id, text: error_handler(e))
      end
    end

    # +PdfUploader::Bot#receive_url(bot)+             -> value
    #
    # This method just counts how many links were filtered (apache links/misc/non-files/etc.)
    #
    # @private
    # @param [PdfUploader::Parser] links Array of links and theirs count.
    # @return [Integer]
    def filtered(links)
      links[1] - links.first.size
    end

    # +PdfUploader::Bot#error_handler(error)+         -> value
    #
    # This method just returns error description according to error class. Nothing special...
    #
    # @private
    # @param [StandardError]
    # @return [String]
    def error_handler(error)
      return 'Invalid url.' if error.is_a?(NoMethodError)

      'Provided link is not an index of resource. Report if there is a problem.'
    end

    # +PdfUploader::Bot#error_handler(error)+         -> value
    #
    # This method just forms string with commands ant theirs description.
    #
    # @private
    # @return [String]
    def commands
      @commands ||= COMMANDS.each_with_object('') do |(k, v), obj|
        obj << "#{k}: #{v}\n"
      end
    end
  end
end

bot = PdfUploader::Bot.new(token:)
bot.start!
