class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name
      t.string :crypted_password
      t.string :salt
      t.column :gender, 'tinyint', default: 0
      t.column :only_same_gender_default, 'tinyint', default: 0
      t.timestamps                null: false
    end
  end
end
