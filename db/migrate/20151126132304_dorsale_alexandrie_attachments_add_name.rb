class DorsaleAlexandrieAttachmentsAddName < ActiveRecord::Migration
  def change
    add_column :dorsale_alexandrie_attachments, :name, :string

    Dorsale::Alexandrie::Attachment.all.each do |a|
      a.update!(name: a.file_identifier)
    end
  end
end
