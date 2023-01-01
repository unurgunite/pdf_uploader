# frozen_string_literal: true

module PdfUploader
  module Parser
    class << self
      def parse!(url)
        site = HTTParty.get(url)
        document = Nokogiri::HTML(site)
        document.search('a').each_with_object(Array.new(2) { |i| [] if i.zero? }).with_index(1) do |(el, arr), i|
          next if (href = el['href']) == '../' || href.end_with?('/') || apache?(href)

          arr[0] << "#{url}#{href}"
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
