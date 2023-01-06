# frozen_string_literal: true

module PdfUploader
  # A +PdfUploader::Parser+ is an interface represented Parser of "Index of" links.
  module Parser
    class << self
      # @todo Add support for other resources -- not only "Index of".
      FILE_REGEX = %r{https?://[\w.-]+(?:/[\w.-]+)*/([\w.-]+\.\w{2,})}

      # +PdfUploader::Parser.parse!(url)+             -> [Array[String], Integer]
      #
      # This method parses <code><a></code> HTML tags, presented in file browser. It saves the
      # paths to the files in an array, and also indicates the number of these
      # files for further analysis.
      #
      # @param [PdfUplaoder::URL] url the URL of the page to parse.
      # @raise [NotImplementedError] if there is no "Index of" title in provided link.
      # @return [Array<Array<String>, Integer>]
      def parse!(url)
        site = HTTParty.get(url)
        document = Nokogiri::HTML(site)
        raise NotImplementedError unless contains?(document)

        search_links(document)
      end

      private

      # +PdfUploader::Parser.contains?(document)+     -> bool
      #
      # A predicate method to check if "Index of" words are provided.
      #
      # @private
      # @return [TrueClass] if link contains "Index of" words.
      # @return [FalseClass] if link does not contain "Index of" words.
      def contains?(document)
        document.at('title:contains("Index of")') || document.at('h1:contains("Index of")')
      end

      # +PdfUploader::Parser.search_links(document)+  -> bool
      #
      # A private method to search links on a page.
      #
      # @private
      # @param [Nokogiri::HTML4::Document] document An HTML document.
      # @return [Array<Array<String>, Integer>]
      def search_links(document)
        arr = Array.new(3) { |i| [] if i.zero? }
        document.search('a').each_with_index do |el, i|
          href = el['href']
          next if skip_link?(href)

          arr[0] << (PdfUploader::URL.new(href).url? ? href.to_s : "#{url}#{href}")
          arr[1] = i + 1
        end
        arr
      end

      # +PdfUploader::Parser.skip_link?(href)+        -> bool
      #
      # Helper method which checks if link should be skipped in a loop
      #
      # @private
      # @param [String] href Hypertext reference for file.
      # @return [Boolean]
      def skip_link?(href)
        href == '../' || href.end_with?('/') || apache?(href)
      end

      # +PdfUploader::Parser.apache?+                 -> bool
      #
      # This method checks if parsed link is Apache web server link. It is known after Apache mod_autoindex sorting
      # method. For further reading go
      # to {Apache documentation}[https://httpd.apache.org/docs/current/mod/mod_autoindex.html].
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
