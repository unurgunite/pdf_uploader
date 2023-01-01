module PdfUploader
  class URL < DelegateClass(String)
    def update_url!
      end_with?('/') ? self : "#{self}/"
    end
  end
end
