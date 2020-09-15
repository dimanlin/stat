class CreatePageviews < ActiveRecord::Migration[6.0]
  def change
    create_table :page_views do |t|
      t.bigint :visit_id
      t.string :title
      t.integer :position
      t.string :url
      t.string :time_spent
      t.decimal :timestamp, precision: 14, scale: 3
      t.timestamps
    end
  end
end
