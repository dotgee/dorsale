class Dorsale::BillingMachine::Quotation::Copy < ::Dorsale::Service
  attr_accessor :quotation, :copy

  def initialize(quotation)
    @quotation = quotation
  end

  def call
    @copy = quotation.dup

    @quotation.lines.each do |line|
      @copy.lines << line.dup
    end

    @copy.unique_index = nil
    @copy.created_at   = nil
    @copy.updated_at   = nil
    @copy.date         = Time.zone.now.to_date
    @copy.state        = ::Dorsale::BillingMachine::Quotation::STATES.first

    @copy.save!

    @quotation.attachments.each do |attachment|
      new_attachment            = attachment.dup
      new_attachment.attachable = @copy
      new_attachment.file       = File.open(attachment.file.path)
      new_attachment.save!
    end

    @copy
  end
end
