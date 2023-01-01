# frozen_string_literal: true

module PdfUploader
  class URL < DelegateClass(String)
    def update_url!
      end_with?('/') ? self : PdfUploader::URL.new("#{self}/")
    end

    def url?
      uri = URI.parse(self)
      HTTParty.get(self).code == 200 if uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end
  end
end
