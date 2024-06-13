class CreateWorkoutScheduleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_schedule_details do |t|
      t.integer :workout_schedule_id, comment: 'ワークアウト予定ID'
      t.integer :exercise_id, comment: 'エクササイズ ID'
      t.json :sets, comment: '重量とrep数を何秒休憩で何セットやったのかをJSONで保持'
      t.integer :one_rep_max_theoretical, comment: 'selectしやすいように1set目の重量と回数から理論上の1rmをあらかじめ算出し別途保存'
      t.timestamps
    end
  end
end
