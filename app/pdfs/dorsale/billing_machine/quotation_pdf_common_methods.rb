module Dorsale::BillingMachine::QuotationPdfCommonMethods
  def build
    super
    build_attachments
  end

  def build_attachments
    main_document.attachments.each do |attachment|
      next unless File.extname(attachment.file.path) == ".pdf"

      file     = attachment.file.path
      nb_pages = ::CombinePDF.load(file).pages.count

      nb_pages.times do |i|
        start_new_page template: file, template_page: (i+1)
      end
    end
  end

  def build_bank_informations
  end

  def build_expiry
    return if main_document.expires_at.nil?

    top    = bounds.top - 11.5.cm
    height = 0.5.cm
    width  = 7.5.cm

    bounding_box [bounds.left, top], height: height, width: width do
      draw_bounds_debug
      text "<b>#{main_document.t(:expires_at)}</b> #{I18n.l(main_document.expires_at)}", inline_format: true, size: 9
    end
  end
end
