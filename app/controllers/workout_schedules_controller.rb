class WorkoutSchedulesController < ApplicationController
  def new
  end

  def create
    begin

      if params[:date].blank?
        flash[:alert] = '日付が入力されていません。'
        redirect_to new_workout_schedule_path and return
      end

      formatted_params = format_params(params)

      formatted_params[:user_id] = current_user.id

      Rails.logger.info("Formatted Params: #{formatted_params.inspect}")

      @workout_schedule = WorkoutSchedule.new(formatted_params)
      Rails.logger.info("Workout Schedule: #{@workout_schedule.inspect}")

      if @workout_schedule.save
        flash[:notice] = 'ワークアウトの予定が作成されました。'
      else
        flash[:alert] = 'ワークアウトの予定が作成に失敗しました。'
        Rails.logger.error("Workout Schedule Save Errors: #{@workout_schedule.errors.full_messages.join(", ")}")
      end

      redirect_to main_path
    rescue Date::Error => e
      flash[:alert] = "無効な日付が入力されました: #{e.message}"
      Rails.logger.error("Date Error: #{e.message}")
      raise
      redirect_to main_path
    rescue => e
      flash[:alert] = "エラーが発生しました: #{e.message}"
      Rails.logger.error("Runtime Error: #{e.message}")
      raise
      redirect_to main_path
    end
  end

  def search
    date = params[:date]
    @workout_schedules = WorkoutSchedule.includes(:user).where.not(googlemap_place_id: WorkoutSchedule::DUMMY_PLACE_ID)
                                        .where('start_at LIKE ? OR finish_at LIKE ?', "%#{date}%", "%#{date}%")
                                        .where.not(user_id: current_user.id)

    respond_to do |format|
      format.json do
        render json: @workout_schedules.as_json(include: {
          user: {
            only: [:name, :gender],
            methods: [:gender_in_japanese]
          }
        })
      end
    end
  end

  def index
    @workout_schedules = WorkoutSchedule.includes(:user)
                                        .where(user_id: current_user.id)
                                        .where.not(googlemap_place_id: WorkoutSchedule::DUMMY_PLACE_ID)
                                        .order(start_at: :desc)
                                        .limit(WorkoutSchedule::INITIAL_LOAD_COUNT)
    @total_count = WorkoutSchedule.where(user_id: current_user.id)
                                  .where.not(googlemap_place_id: WorkoutSchedule::DUMMY_PLACE_ID)
                                  .count
  end

  def load_more
    offset = params[:offset].to_i
    @workout_schedules = WorkoutSchedule.includes(:user)
                                        .where(user_id: current_user.id)
                                        .where.not(googlemap_place_id: WorkoutSchedule::DUMMY_PLACE_ID)
                                        .order(start_at: :desc)
                                        .offset(offset)
                                        .limit(WorkoutSchedule::LOAD_MORE_COUNT)

    respond_to do |format|
      format.js
    end
  end

  def show
    @workout_schedule = WorkoutSchedule.find(params[:id])
  end

  def edit
    raise
  end

  private

  def format_params(params)
    workout_params = params.require(:workout_schedule).permit(:googlemap_place_id, :googlemap_place_name, :googlemap_place_lat, :googlemap_place_lng, :do_leg, :do_chest, :do_back, :do_arm, :do_shoulder, :only_same_gender, :looks, :date)

    # 日付と時間を結合して start_at と finish_at を作成
    begin
      date_params = params[:date].split('-').map(&:to_i)

      start_at = DateTime.new(date_params[0], date_params[1], date_params[2],
                              params[:workout_schedule]["start_at(4i)"].to_i,
                              params[:workout_schedule]["start_at(5i)"].to_i)

      finish_at = DateTime.new(date_params[0], date_params[1], date_params[2],
                               params[:workout_schedule]["finish_at(4i)"].to_i,
                               params[:workout_schedule]["finish_at(5i)"].to_i)
    rescue ArgumentError => e
      raise Date::Error.new("Invalid date: #{e.message}")
    end

    workout_params.merge(start_at: start_at, finish_at: finish_at)
  end

  def workout_schedule_params
    params.require(:workout_schedule).permit(:user_id, :googlemap_place_id, :googlemap_place_name, :googlemap_place_lat, :googlemap_place_lng, :start_at, :finish_at, :do_leg, :do_chest, :do_back, :do_arm, :do_shoulder, :only_same_gender, :looks, :date)
  end
end
