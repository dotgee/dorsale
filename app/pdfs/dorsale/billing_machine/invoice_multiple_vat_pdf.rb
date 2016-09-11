class Dorsale::BillingMachine::InvoiceMultipleVatPdf < ::Dorsale::BillingMachine::InvoiceSingleVatPdf
  def first_column_width;  64.mm; end
  def second_column_width; 22.mm; end
  def third_column_width;  20.mm; end
  def fourth_column_width; 20.mm; end
  def fifth_column_width;  29.mm; end
  def last_column_width
    bounds.width - first_column_width - second_column_width - third_column_width - fourth_column_width - fifth_column_width
  end

  def build_table
    left   = bounds.left
    top    = bounds.top
    width  = bounds.width - left

    bounding_box [left, top], width: width, height: products_table_height do
      repeat :all do
        float do
            table [["","","","","",""]],
                :column_widths => [first_column_width, second_column_width, third_column_width, fourth_column_width, fifth_column_width, last_column_width],
                :cell_style => {height: products_table_height} do
                  row(0).style :text_color       => BLACK
                  row(0).style :font_style       => :bold
                  column(0).style :align => :left
                  column(1..4).style :align => :right
                end
             end
          end
      end

    bounding_box [left, top], width: width, height: products_table_height do
      draw_bounds_debug

      table_products = [[
        main_document.t(:designation).mb_chars.upcase.to_s,
        main_document.t(:quantity).mb_chars.upcase.to_s,
        main_document.t(:unit).mb_chars.upcase.to_s,
        main_document.t(:tax).mb_chars.upcase.to_s,
        main_document.t(:unit_price).mb_chars.upcase.to_s,
        main_document.t(:line_total).mb_chars.upcase.to_s,
      ]]


      main_document.lines.each do |line|
        table_products.push [line.label,
            number(line.quantity).gsub(",00","").gsub(".00",""),
            line.unit,
            percentage(line.vat_rate),
            bm_currency(line.unit_price),
            bm_currency(line.total),]
      end

    table table_products,
      :column_widths => [first_column_width, second_column_width, third_column_width, fourth_column_width, fifth_column_width, last_column_width],
      :header => true,
      :cell_style    => {border_width: 0} do
        row(0).font_style = :bold
        row(0).border_width = 1,
        cells.style do |c|
          c.align = c.column == 0 ? :left : :right
        end
      end
    end
  end

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

      table_totals.push [
        main_document.t(:vat_amount).mb_chars.upcase.to_s,
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
        :column_widths => [fifth_column_width , last_column_width],
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
        rectangle [(bounds.right - fifth_column_width - last_column_width), bounds.top], (fifth_column_width + last_column_width), (bounds.top-cursor)
      end
    end
  end

end
