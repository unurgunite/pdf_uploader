# frozen_string_literal: true

module PdfUploader
  module Parser
    class << self
      def parse!(url)
        url = PdfUploader::URL.new(url).update_url!
        site = HTTParty.get(url)
        document = Nokogiri::HTML(site)
        document.search('a').each_with_object([]) do |el, arr|
          next if (href = el['href']) == '../'

          arr << "#{url}#{href}"
        end
      end
    end
  end
end
