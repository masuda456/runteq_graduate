class CreateWorkoutSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_schedules do |t|
      t.integer :user_id, comment: 'ユーザーID'
      t.string :googlemap_place_id, comment: 'Google Mapsの場所ID'
      t.string :googlemap_place_name, comment: 'Google Mapsの場所の名前'
      t.decimal :googlemap_place_lat, precision: 10, scale: 6, comment: 'Google Mapsの場所の緯度'
      t.decimal :googlemap_place_lng, precision: 10, scale: 6, comment: 'Google Mapsの場所の経度'
      t.datetime :start_at, comment: 'ワークアウトの開始時間'
      t.datetime :finish_at, comment: 'ワークアウトの終了時間'
      t.integer :do_leg, limit: 1, comment: '脚のエクササイズ 0:行わない 1:行う'
      t.integer :do_chest, limit: 1, comment: '胸のエクササイズ 0:行わない 1:行う'
      t.integer :do_back, limit: 1, comment: '背中のエクササイズ 0:行わない 1:行う'
      t.integer :do_arm, limit: 1, comment: '腕のエクササイズ 0:行わない 1:行う'
      t.integer :do_shoulder, limit: 1, comment: '肩のエクササイズ 0:行わない 1:行う'
      t.integer :only_same_gender, limit: 1, comment: '0: 性別を問わず検索される 1:同性のユーザーからのみ検索される'
      t.string :looks, comment: '当日の服装など'
      t.timestamps
    end
  end
end
