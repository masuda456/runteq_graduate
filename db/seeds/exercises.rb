ActiveRecord::Base.transaction do
  # exercisesテーブルのデータを全削除
  Exercise.delete_all

  # 新しいデータを挿入
  Exercise.create!([
    { name: 'ベンチプレス', created_at: Time.now, updated_at: Time.now },
    { name: 'スクワット', created_at: Time.now, updated_at: Time.now },
    { name: 'デッドリフト', created_at: Time.now, updated_at: Time.now }
  ])
end
