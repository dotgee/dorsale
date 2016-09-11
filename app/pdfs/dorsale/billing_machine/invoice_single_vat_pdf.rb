require "prawn/measurement_extensions"

class Dorsale::BillingMachine::InvoiceSingleVatPdf < Prawn::Document
  include Dorsale::Alexandrie::Prawn
  include Dorsale::AllHelpers
  include ActionView::Helpers::NumberHelper
  DEBUG = false

  GREY       = "808080"
  LIGHT_GREY = "C0C0C0"
  WHITE      = "FFFFFF"
  BLACK      = "000000"
  BLUE       = "005F9E"

  def bm_currency(n)
    currency(n, Dorsale::BillingMachine.default_currency)
  end

  def has_advance
    main_document.try(:advance) && main_document.advance != 0.0
  end

  def has_discount
    main_document.try(:commercial_discount) && main_document.commercial_discount != 0.0
  end

  attr_reader :main_document

  def initialize(main_document)
    super(page_size: 'A4', margin: 1.cm)
    setup
    @main_document = main_document
    @id_card       = main_document.id_card
  end

  def header_height;         90.mm; end
  def logo_height;           32.mm; end
  def logo_width;            50.mm; end

  def footer_height;         40.mm; end
  def footer_top_height;     15.mm; end
  def footer_bottom_height;  15.mm; end

  def middle_height;         14.cm; end
  def products_table_height; 90.mm; end

  def first_column_width;  7.6.cm; end
  def second_column_width; 2.4.cm; end
  def third_column_width;  2.5.cm; end
  def fourth_column_width; 2.9.cm; end
  def last_column_width
    bounds.width - first_column_width - second_column_width - third_column_width - fourth_column_width
  end

  def build
    repeat :all do
      build_header
      build_footer
    end

    build_middle
    build_page_numbers
  end

  def setup
    font_root = ::Dorsale::Engine.root.join("app/assets/fonts")
    font_families.update(
      "BryantPro" => {
        normal: "#{font_root}/BryantPro-Regular.ttf",
        bold:   "#{font_root}/BryantPro-Bold.ttf",
      }
    )

    font("BryantPro")
    font_size 10
  end

  def build_header
    bounding_box [0, bounds.top], width: bounds.width, height: header_height do
      draw_bounds_debug
      build_title
      build_logo
      build_contact
      build_subject
      build_customer
    end
  end

  def build_title
    top    = bounds.top - 1.5.cm
    left   = bounds.left
    width  = bounds.width
    height = 1.cm
    bounding_box [left, top], width: width, height: height do
      draw_bounds_debug
      text "<b>#{main_document.t} n° #{main_document.tracking_id}</b>", inline_format: true, size: 20, align: :center
    end
  end

  def logo_path
    main_document.id_card.logo.path
  rescue NoMethodError
    nil
  end

  def build_logo
    return if logo_path.nil?

    height = logo_height
    width  = logo_width

    bounding_box [bounds.left, bounds.top], width: width, height: height do
      draw_bounds_debug
      image logo_path, fit: [width, height]
    end
  end

  def contact_address_line
    [
      @id_card.address1,
      @id_card.address2,
      @id_card.zip,
      @id_card.city,
    ].select(&:present?).join(", ")
  end

  def contact_content
    content = []
    content << "<b>#{@id_card.entity_name}</b>"                                           if @id_card.entity_name.present?
    content << "<b>#{contact_address_line}</b>"                                           if contact_address_line.present?
    content << " "
    content << "<b>#{main_document.t(:your_contact)} : #{@id_card.contact_full_name}</b>" if @id_card.contact_full_name.present?
    content << "<b>#{main_document.t(:contact_phone)} : </b> #{@id_card.contact_phone}"   if @id_card.contact_phone.present?
    content << "<b>#{main_document.t(:contact_fax)} : </b> #{@id_card.contact_fax}"       if @id_card.contact_fax.present?
    content << "<b>#{main_document.t(:contact_email)} : </b> #{@id_card.contact_email}"   if @id_card.contact_email.present?
    content.join("\n")
  end

  def build_contact
    top    = bounds.top - 4.cm
    left   = bounds.left
    width  = bounds.width / 2 - 1.1.cm
    height = 2.5.cm

    bounding_box [left, top], width: width, height: height do
      draw_bounds_debug
      text contact_content, inline_format: true, size: 8
    end
  end

  def build_subject
    top    = bounds.top - 7.5.cm
    left   = bounds.left
    width  = bounds.width / 2 - 1.1.cm
    height = 15.mm

    bounding_box [left, top], width: width, height: height do
      draw_bounds_debug

      if main_document.label.present?
        text "<b>#{main_document.t(:label)} : </b> #{main_document.label}", inline_format: true
      end

      if main_document.date.present?
        move_down 3.mm
        text "<b>#{main_document.t(:date)} : </b> #{date main_document.date}", inline_format: true
      end
    end
  end

  def customer_content
    return if main_document.customer.nil?

    content = []
    content << main_document.customer.name
    content << main_document.customer.address.street
    content << main_document.customer.address.street_bis
    content << "#{main_document.customer.address.zip} #{main_document.customer.address.city}"
    content << main_document.customer.address.country

    if main_document.customer.try(:european_union_vat_number).present?
      content << main_document.customer.t(:european_union_vat_number)
      content << main_document.customer.european_union_vat_number
    end

    content.select(&:present?).join("\n")
  end

  def build_customer
    top    = bounds.top - 4.cm
    left   = bounds.width / 2 + 1.1.cm
    width  = bounds.width / 2 - 1.1.cm
    height = 4.5.cm
    padding = 3.mm

    bounding_box [left, top], width: width, height: height do
      draw_bounds_debug
      stroke do
        fill_color LIGHT_GREY
        fill_rounded_rectangle [cursor-bounds.height,cursor], bounds.width, bounds.height, 0
        fill_color BLACK
      end

      bounding_box [bounds.left + padding, bounds.top - padding], height: bounds.height - padding, width: bounds.width - padding do
        text customer_content
      end
    end
  end # def build_customer

  def build_middle
    left   = bounds.left
    top    = bounds.top - header_height
    width  = bounds.width - left
    height = middle_height

    bounding_box [left, top], width: width, height: height do
      build_table
      build_total
      build_payment_conditions
      build_bank_informations
      build_expiry
      build_comments
    end
  end

  def build_table
    left   = bounds.left
    top    = bounds.top
    width  = bounds.width - left
    height = products_table_height

    # Empty table to draw lines
    bounding_box [left, top], width: width, height: height do
      repeat :all do
        float do
          table [["","","","",""]],
            :column_widths => [
              first_column_width,
              second_column_width,
              third_column_width,
              fourth_column_width,
              last_column_width,
            ],
            :cell_style => {height: height} \
          do
            row(0).style       :text_color => BLACK
            row(0).style       :font_style => :bold
            column(0).style    :align      => :left
            column(1..4).style :align      => :right
          end # table
        end # float
      end # repeat all
    end # bounding_box

    # products table
    bounding_box [left, top], width: width, height: height do
      draw_bounds_debug

      table_products = [[
        main_document.t(:designation).mb_chars.upcase.to_s,
        main_document.t(:quantity).mb_chars.upcase.to_s,
        main_document.t(:unit).mb_chars.upcase.to_s,
        main_document.t(:unit_price).mb_chars.upcase.to_s,
        main_document.t(:line_total).mb_chars.upcase.to_s,
      ]]

      main_document.lines.each do |line|
        table_products.push [
          line.label,
          number(line.quantity).gsub(",00","").gsub(".00",""),
          line.unit,
          bm_currency(line.unit_price),
          bm_currency(line.total),
        ]
      end

      table table_products,
        :column_widths => [
          first_column_width,
          second_column_width,
          third_column_width,
          fourth_column_width,
          last_column_width,
        ],
        :header => true,
        :cell_style => {border_width: 0} \
      do
        row(0).font_style = :bold
        row(0).border_width = 1,
        cells.style { |c| c.align = c.column == 0 ? :left : :right }
      end # table
    end # bounding_box
  end # build_table

  def build_total
    left   = bounds.left
    top    = bounds.top - products_table_height - 5.mm
    width  = bounds.width - left
    height = middle_height - products_table_height

    bounding_box [left, top], width: width, height: height do
      draw_bounds_debug

      table_totals = [[]]

      if has_discount
        table_totals.push [
          main_document.t(:commercial_discount).mb_chars.upcase.to_s,
          bm_currency(-main_document.commercial_discount),
        ]
      end

      table_totals.push [
        main_document.t(:total_excluding_taxes).mb_chars.upcase.to_s,
        bm_currency(main_document.total_excluding_taxes),
      ]

      vat_rate = number(main_document.vat_rate)
      table_totals.push [
        "#{main_document.t(:vat).mb_chars.upcase.to_s} #{percentage vat_rate}",
        bm_currency(main_document.vat_amount),
      ]

      if has_advance
        table_totals.push [
          main_document.t(:advance).mb_chars.upcase.to_s,
          bm_currency(main_document.advance),
        ]

        table_totals.push [
          main_document.t(:total_including_taxes).mb_chars.upcase.to_s,
          bm_currency(main_document.balance),
        ]
      else
        table_totals.push [
          main_document.t(:total_including_taxes).mb_chars.upcase.to_s,
          bm_currency(main_document.total_including_taxes),
        ]
      end

      table table_totals,
        :column_widths => [fourth_column_width, last_column_width],
        :cell_style    => {border_width: [0, 1, 0 ,0]},
        :position      => :right do
          row(-1).style :font_style       => :bold
          column(0).padding_right = 0.2.cm
          row(-1).borders = [:top, :right]
          row(-1).border_width = 1
          cells.style do |c|
            c.align = :right
          end
        end
      stroke do
        rectangle [(bounds.right - fourth_column_width - last_column_width), bounds.top], (fourth_column_width + last_column_width), (bounds.top-cursor)
      end
    end
  end

  def build_comments
    return if main_document.comments.blank?

    top    = bounds.top - products_table_height - 35.mm
    height = top - bounds.bottom
    width  = 10.cm

    text_box main_document.comments,
      :at       => [bounds.left, top],
      :height   => height,
      :width    => width,
      :overflow => :shrink_to_fit,
      :size     => 9
  end

  def build_payment_conditions
    return if main_document.payment_term.blank?

    top    = bounds.top - products_table_height - 5.mm
    height = 15.mm
    width  = 7.5.cm

    txt = "<b>#{main_document.t(:payment_terms)}</b> : #{main_document.payment_term}"

    text_box txt,
      :at            => [bounds.left, top],
      :height        => height,
      :width         => width,
      :overflow      => :shrink_to_fit,
      :inline_format => true,
      :size          => 9
  end

  def build_expiry
  end

  def build_bank_informations
    top = bounds.top - products_table_height - 20.mm
    height = 1.cm
    width  = 7.5.cm

    bounding_box [bounds.left, top], height: height, width: width do
      draw_bounds_debug
      font_size 9 do
        text "#{main_document.t(:iban)} : #{@id_card.iban}"           if @id_card.iban.present?
        text "#{main_document.t(:bic_swift)} : #{@id_card.bic_swift}" if @id_card.bic_swift.present?
      end
    end
  end

  def build_footer
    top = bounds.bottom + footer_height

    bounding_box [0, top], width: bounds.width, height: footer_height do
      draw_bounds_debug
      build_footer_top
      build_footer_line
      build_footer_bottom
    end
  end

  def footer_top_content
    @id_card.custom_info_1.to_s
  end

  def build_footer_top
    top    = bounds.top
    height = footer_top_height
    width  = bounds.width

    text_box footer_top_content,
      :at       => [bounds.left, top],
      :height   => height,
      :width    => width,
      :overflow => :shrink_to_fit,
      :size          => 9
  end

  def build_footer_line
    # Center line between the two footer parts
    n = footer_top_height + (footer_height - footer_top_height - footer_bottom_height) / 2
    move_down n
    stroke do
      horizontal_rule
      line_width 1
    end
  end

  def footer_bottom_content
    infos_text = []
    infos_text << @id_card.entity_name                                                                                if @id_card.entity_name.present?
    infos_text << "#{main_document.t(:info_phone)} : #{@id_card.contact_phone}"                                       if @id_card.contact_phone.present?
    infos_text << "#{main_document.t(:info_fax)} : #{@id_card.contact_fax}"                                           if @id_card.contact_fax.present?
    infos_text << "#{@id_card.contact_email}"                                                                         if @id_card.contact_email.present?
    infos_text << "#{@id_card.legal_form.to_s}"                                                                       if @id_card.legal_form.present?
    infos_text << "#{main_document.t(:capital)} : #{bm_currency @id_card.capital}"                                          if @id_card.capital.present?
    infos_text << "#{main_document.t(:registration)} : #{@id_card.registration_city} #{@id_card.registration_number}" if @id_card.registration_number.present?
    infos_text << "#{main_document.t(:siret)} : #{@id_card.siret}"                                                    if @id_card.siret.present?
    infos_text << "#{main_document.t(:intracommunity_vat)} : #{@id_card.intracommunity_vat}"                          if @id_card.intracommunity_vat.present?
    infos_text = infos_text.join(" - ")
  end

  def build_footer_bottom
    height = footer_bottom_height
    top    = bounds.bottom + height
    width  = bounds.width

    text_box footer_bottom_content,
      :at       => [bounds.left, top],
      :height   => height,
      :width    => width,
      :overflow => :shrink_to_fit,
      :size     => 9
  end

  def build_page_numbers
    height = 5.mm
    top    = bounds.bottom + height
    width  = bounds.width

    bounding_box [0, top], height: height, width: bounds.width do
      float do
        number_pages "page <page>/<total>", align: :right, size: 9
      end
    end
  end

  def draw_bounds_debug
    transparent(0.5) { stroke_bounds } if DEBUG
  end
end
