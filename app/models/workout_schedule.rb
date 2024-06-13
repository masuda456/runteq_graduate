class WorkoutSchedule < ApplicationRecord
  belongs_to :user
  has_many :workout_schedule_details

  def self.create_dummy_by_user(user, exercises)
    workout_schedule = create!(
      user: user,
      start_at: DateTime.new(1900, 1, 1, 0, 0, 0),
      finish_at: DateTime.new(1900, 1, 1, 0, 0, 1),
      do_leg: 0,
      do_chest: 0,
      do_back: 0,
      do_arm: 0,
      do_shoulder: 0,
      only_same_gender: 0
    )
    workout_schedule.create_details(exercises)
    workout_schedule
  end

  def create_details(exercises)
    exercises.each do |exercise_id, one_rep_max_theoretical|
      next if one_rep_max_theoretical.blank?

      workout_schedule_details.create(
        exercise_id: exercise_id,
        one_rep_max_theoretical: one_rep_max_theoretical
      )
    end
  end
end
