class UsersController < ApplicationController
  #before_action :set_user, only: %i[ show edit update destroy ]
  load_and_authorize_resource :except => ["index", "search"]

  # GET /users or /users.json
  def index
    @users = User.accessible_by(current_ability).page(params[:page])
    dir = params[:dir] || "asc"
    order_by = params[:order_by] || "users.id"
    order_by += " " + dir
    @dir = (dir == "asc") ? "desc" : "asc"

    type_id = SupportRequestType.find_by(alias: "time off notification")&.id
    start_date = params.fetch(:start_date, Date.today).to_date

    if (params["user"] && params["user"]["start_date"] && params["user"]["end_date"]).present?
      start_date = params["user"]["start_date"]
      end_date = params["user"]["end_date"]
      @number_of_days = (start_date.to_date - end_date.to_date) + 1
      @time_of_notifications =  SupportRequest.includes(:user).where(support_request_type_id: type_id).where("start_date >= ? && end_date <=?", start_date.to_date, end_date.to_date)
    else
      start_date = Date.today.beginning_of_month
      end_date = Date.today.end_of_month
      @time_of_notifications =  SupportRequest.includes(:user).where(support_request_type_id: type_id).where("start_date >= ? && end_date <=?", start_date, end_date )
    end

    @users = User.order(order_by).page(params[:page])
  end

  def search
    conditions = []
    if params[:query].present?
      conditions = user_global_search_helper(params[:query])
    end
    @users = User.where(conditions).accessible_by(current_ability).order(created_at: :desc).page(params[:page])
    render "index"
  end

  # GET /users/1 or /users/1.json
  def show
    if params[:print].present?
      render(:layout => "layouts/print")
    end
  end

  def closed_without_docs
    session[:is_closed_without_docs] = true
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if @user.bio.blank?
      @user.bio = " #{@user.full_name} - Hired YYYY <br>
      Year of Birth - YYYY <br>
      Caregiver - XX+ years <br>
      State License - <br>
      Criminal Background - None <br>
      Contact number - #{@user.phone} <br>
      <br>
      <br>
      Brief Summary Here
      "
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.role = "User" if (current_user && current_user.role != "Manager")
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    # Default the role to user to prevent priv escalation
    up = user_params
    if current_user.role != "Manager"
      up[:role] = "User"
      # logger.debug  "user_params = #{up}"
    end

    respond_to do |format|
      if @user.update(up)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :role, :earnings, :deactivated,
        :emergency_contact_name, :emergency_contact_phone, :profile_image, :bio, :phone, :password, :password_confirmation)
    end
end
