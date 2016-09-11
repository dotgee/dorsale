CSV.generate({force_quotes: true, col_sep: ";" }) do |csv|
  column_names = [
    "Date",
    "Numéro",
    "Objet",
    "Client",
    "Adresse 1",
    "Adresse 2",
    "Code postal",
    "Ville",
    "Pays",
    "Remise commerciale",
    "Montant HT",
    "Montant TVA",
    "Montant TTC",
    "Acompte",
    "Solde à payer"
  ]

  csv << column_names

  @invoices_without_pagination.each do |invoice|
    csv << [
      invoice.date,
      invoice.tracking_id,
      invoice.label,
      invoice.customer.try(:name),
      invoice.customer.try(:address).try(:street),
      invoice.customer.try(:address).try(:street_bis),
      invoice.customer.try(:address).try(:zip),
      invoice.customer.try(:address).try(:city),
      invoice.customer.try(:address).try(:country),
      number(invoice.commercial_discount),
      number(invoice.total_excluding_taxes),
      number(invoice.vat_amount),
      number(invoice.total_including_taxes),
      number(invoice.advance),
      number(invoice.balance)
    ]
  end
end.encode("WINDOWS-1252",
  :crlf_newline => true,
  :invalid      => :replace,
  :undef        => :replace,
  :replace      => "?"
)
