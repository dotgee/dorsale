filename = [
  @quotation.t.capitalize,
  @quotation.tracking_id,
  @quotation.customer.try(:short_name),
].join("_").concat(".pdf")

response.headers["Content-Disposition"] = %(inline; filename="#{filename}")

@quotation.to_pdf
