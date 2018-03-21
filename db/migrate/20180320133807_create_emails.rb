class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.string :address
      t.references :setting

      t.timestamps
    end

    add_index :emails, :address, unique: true
  end
end
