class CreateHasTags < ActiveRecord::Migration[6.1]
  def change
    create_table :has_tags do |t|
      t.belongs_to :product
      t.belongs_to :tag
    end
  end
end
