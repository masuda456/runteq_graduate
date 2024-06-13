class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :workout_schedules
  has_many :workout_schedule_details, through: :workout_schedules
  has_and_belongs_to_many :exercises

  enum gender: { unknown: 0, male: 1, female: 2 }

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true, presence: true

  def create_workout_schedule_and_details(exercises_params)
    workout_schedule = workout_schedules.create
    exercises_params.each do |exercise_id, one_rep_max_theoretical|
      next if one_rep_max_theoretical.blank?

      exercise = Exercise.find(exercise_id)
      workout_schedule.workout_schedule_details.create(
        exercise_id: exercise.id,
        one_rep_max_theoretical: one_rep_max_theoretical
      )
    end
  end
end
