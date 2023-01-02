# frozen_string_literal: true

module PdfUploader
  # A +PdfUploader::URL+ module contains methods for working with incoming URL from user.
  # It is a backend for +PdfUploader::Parser+ module.
  class URL < DelegateClass(String)
    # +PdfUploader::URL#update_url!+                  -> self | PdfUploader::URL
    #
    # This method checks if there is a slash at the end of the URL. If there is no slash, this
    # method will return an instance of URL object -- a string contained slash.
    #
    # @return [self] if there is a slash.
    # @return [PdfUploader::URL] if there is no slash.
    def update_url!
      end_with?('/') ? self : PdfUploader::URL.new("#{self}/")
    end

    # +PdfUploader::URL#url?+                         -> bool
    #
    # This method checks if given link is valid. It parsers it via URI class from std core lib and
    # analyze it. If everything is ok, method will make a request. Link will be valid if the request
    # returns the code 200.
    #
    # @raise [URI::InvalidURIError] if URI is invalid.
    # @return [TrueClass] if request returns 200.
    # @return [FalseClass] if exception raised or HTTP status is not 200.
    def url?
      uri = URI.parse(self)
      HTTParty.get(self).code == 200 if uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end
  end
end
