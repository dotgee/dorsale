accounting.settings =
  number:
    precision : 2
    thousand: " " # nbsp
    decimal : ","

window.str2num = (str) ->
  parseFloat(
    String(str)
      .replace(",", ".")
      .replace(/[^-0-9\.]+/g, "")
  ) || 0.0

window.num2str = (num) ->
  num = parseFloat(num)
  accounting.formatNumber(num)

$(document).on "ready turbolinks:load page:load cocoon:after-insert", ->
  $("#billing_machine-form input.number").keyup ->
    total_excluding_taxes = 0.0

    # Update line totals
    $("#billing_machine-form .line").map ->
      return if parseInt($(this).find("input[name*=destroy]").val()) == 1
      quantity   = str2num $(this).find(".line-quantity input").val()
      unit_price = str2num $(this).find(".line-unit_price input").val()
      line_total = unit_price * quantity
      $(this).find(".line-total input").val num2str line_total

      total_excluding_taxes += line_total

    # Substract discount to total excluding taxes
    commercial_discount   = str2num $(".commercial_discount input").val()
    raw_total_excluding_taxes = total_excluding_taxes
    total_excluding_taxes = raw_total_excluding_taxes - commercial_discount
    $(".total_excluding_taxes input").val num2str total_excluding_taxes

    discount_rate = commercial_discount / raw_total_excluding_taxes

    # VAT amount based on each line total with discount rate
    vat_amount = 0.0
    $("#billing_machine-form .line").map ->
      return if parseInt($(this).find("input[name*=destroy]").val()) == 1

      # Per line VAT rate
      if $(this).find(".line-vat_rate input").length > 0
        vat_rate = str2num $(this).find(".line-vat_rate input").val()
      # Global VAT rate
      else
        vat_rate = str2num $("#totals-table .vat_rate input").val()

      line_total = str2num $(this).find(".line-total input").val()
      discounted_line_total = line_total - (line_total * discount_rate)
      line_vat_amount = discounted_line_total * vat_rate / 100
      vat_amount += line_vat_amount
    $(".vat_amount input").val num2str vat_amount

    total_including_taxes = total_excluding_taxes + vat_amount
    $(".total_including_taxes input").val num2str total_including_taxes

    # Advances is for invoices only, not for quotations
    if $(".advance input").length > 0 && $(".balance input").length > 0
      advance = str2num $(".advance input").val()
      balance = total_including_taxes - advance
      $(".balance input").val num2str balance

  # Update amount on page load
  $("#billing_machine-form input").keyup()

  # Format all input correctly
  $("#billing_machine-form input.number").blur ->
    $("#billing_machine-form input.number").map ->
      formatted_number = num2str str2num $(this).val()
      $(this).val formatted_number
  $("#billing_machine-form input.number").blur()

  # Empty number inputs on focus if value is 0
  $("#billing_machine-form input.number").focus ->
    $(this).val("") if str2num($(this).val()) == 0

  # Auto ajust line label textarea height
  $("#billing_machine-form textarea").keyup ->
     this.rows = this.value.split("\n").length
  $("#billing_machine-form textarea").keyup()

  # Fix Cocoon bug
  $("#billing_machine-form .line textarea").map ->
    this.value = this.value.trim()

  # Button to delete line
  $("#billing_machine-form a.delete").click ->
    $(this).parents("td").find("input").val(1)
    $(this).parents("tr").hide()
    $("#billing_machine-form input").keyup() # Update totals
    return false
