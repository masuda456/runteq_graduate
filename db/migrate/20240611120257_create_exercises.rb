class CreateExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :exercises do |t|
      t.string :name, comment: 'エクササイズ名'
      t.timestamps
    end
  end
end
