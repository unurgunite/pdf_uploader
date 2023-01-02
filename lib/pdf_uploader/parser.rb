# frozen_string_literal: true

module PdfUploader
  # A +PdfUploader::Parser+ is an interface represented Parser of "Index of" links.
  module Parser
    class << self
      # @todo Add support for other resources -- not only "Index of".
      FILE_REGEX = %r{https?://[\w.-]+(?:/[\w.-]+)*/([\w.-]+\.\w{2,})}

      # +PdfUploader::Parser.parse!(url)+             -> [Array[String], Integer]
      #
      # This method parses +<a>+ HTML tags, presented in file browser. It saves the
      # paths to the files in an array, and also indicates the number of these
      # files for further analysis.
      #
      # @param [PdfUplaoder::URL] url the URL of the page to parse.
      # @raise [NotImplementedError] if there is no "Index of" title in provided link.
      # @return [Array<Array<String>, Integer>]
      def parse!(url)
        site = HTTParty.get(url)
        document = Nokogiri::HTML(site)
        raise NotImplementedError unless document.at('title:contains("Index of")')

        document.search('a').each_with_object(Array.new(3) { |i| [] if i.zero? }).with_index(1) do |(el, arr), i|
          if (href = el['href']) == '../' || href.end_with?('/') || apache?(href) # || (!href.end_with?('/') && !href.match?(FILE_REGEX))
            next
          end

          arr[0] << (PdfUploader::URL.new(href).url? ? href.to_s : "#{url}#{href}")
          arr[1] = i
        end
      end

      private

      # +PdfUploader::Parser.apache?+                 -> bool
      #
      # This method checks if parsed link is Apache web server link. It is known after Apache mod_autoindex sorting
      # method. For further reading go to {Apache documentation}[https://httpd.apache.org/docs/current/mod/mod_autoindex.html].
      #
      # @private
      # @param [String] href
      # @return [TrueClass] if link matches the regex.
      # @return [FalseClass] if link not matches the regex.
      def apache?(href)
        href.match?(/C=\w+;O=\w+/)
      end
    end
  end
end
