# db/seeds/initialize.rb

# テーブルのトランケート（全削除）
workout_schedule_detail_count = WorkoutScheduleDetail.destroy_all.size
workout_schedule_count = WorkoutSchedule.destroy_all.size
exercise_count = Exercise.destroy_all.size
user_count = User.destroy_all.size

# オートインクリメントをリセット
ActiveRecord::Base.connection.execute("ALTER TABLE users AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE exercises AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE workout_schedule_details AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE workout_schedules AUTO_INCREMENT = 1")

# exercisesの初期データ挿入
exercises = [
  { name: "ベンチプレス", created_at: Time.now, updated_at: Time.now },
  { name: "スクワット", created_at: Time.now, updated_at: Time.now },
  { name: "デッドリフト", created_at: Time.now, updated_at: Time.now }
]

Exercise.create!(exercises)

puts "データの初期化が完了"
puts "Userテーブル削除件数: #{user_count}"
puts "Exerciseテーブル削除件数: #{exercise_count}"
puts "WorkoutScheduleDetailテーブル削除件数: #{workout_schedule_detail_count}"
puts "WorkoutScheduleテーブル削除件数: #{workout_schedule_count}"
