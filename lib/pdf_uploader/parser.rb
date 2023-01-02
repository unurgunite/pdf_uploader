# frozen_string_literal: true

module PdfUploader
  module Parser
    class << self
      FILE_REGEX = %r{https?://[\w.-]+(?:/[\w.-]+)*/([\w.-]+\.\w{2,})}

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

      def apache?(href)
        href.match?(/C=\w+;O=\w+/)
      end
    end
  end
end
