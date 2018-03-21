class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :name
      t.boolean :need_emails, default: false
      t.string :webhook_topic
      t.bigint :webhook_id
      t.string :webhook_action_name
      t.boolean :value, default: false

      t.references :shop

      t.timestamps
    end
  end
end
