class WorkoutScheduleDetail < ApplicationRecord
  belongs_to :workout_schedule, inverse_of: :workout_schedule_details
end
