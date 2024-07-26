class CreateHtmlDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :html_documents do |t|
      t.text :content
      t.integer :processed_status, default: 0

      t.timestamps
    end
  end
end
