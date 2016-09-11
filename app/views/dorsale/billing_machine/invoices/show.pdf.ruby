filename = [
  @invoice.t.capitalize,
  @invoice.tracking_id,
  @invoice.customer.try(:short_name),
].join("_").concat(".pdf")

response.headers["Content-Disposition"] = %(inline; filename="#{filename}")

@invoice.to_pdf
