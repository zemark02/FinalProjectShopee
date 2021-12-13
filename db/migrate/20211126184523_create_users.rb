class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :name
      t.string :address
      t.string :phone
      t.string :gender
      t.date :birthdate

      t.timestamps
    end
  end
end
