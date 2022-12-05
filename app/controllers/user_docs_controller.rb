class UserDocsController < ApplicationController
  #before_action :set_user_doc, only: %i[ show edit update destroy ]
  before_action :user_docoments_type, only: %i[new edit destroy ]
  load_and_authorize_resource :except => ["index", "search"]


  # GET /user_docs or /user_docs.json
  def index
    @user_docs = UserDoc.accessible_by(current_ability).includes(:document_type, :user, :attachment_blob).page(params[:page])
    dir = params[:dir] || "desc"
    order_by = params[:order_by] || "user_docs.id"
    order_by += " " + dir
    @dir = (dir == "desc") ? "asc" : "desc"
    @user_docs = @user_docs.includes(:user).order(order_by)
  end

  def search
    conditions = []
    if params[:query].present?
      conditions = user_docs_global_search_helper(params[:query])
    end
    @user_docs = UserDoc.joins(:user).accessible_by(current_ability)
    @user_docs = @user_docs.where(conditions).order(created_at: :desc).page(params[:page])
    render "index"
  end

  # GET /user_docs/1 or /user_docs/1.json
  def show
  end

  # GET /user_docs/new
  def new
    @user_doc = UserDoc.new
  end

  # GET /user_docs/1/edit
  def edit
  end

  # POST /user_docs or /user_docs.json
  def create
    @user_doc = UserDoc.new(user_doc_params)
    @user_doc.user_id = current_user.id

    respond_to do |format|
      if @user_doc.save
        format.html { redirect_to @user_doc, notice: "User document was successfully created." }
        format.json { render :show, status: :created, location: @user_doc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_docs/1 or /user_docs/1.json
  def update
    respond_to do |format|
      if @user_doc.update(user_doc_params)
        format.html { redirect_to @user_doc, notice: "User document was successfully updated." }
        format.json { render :show, status: :ok, location: @user_doc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_docs/1 or /user_docs/1.json
  def destroy
    @user_doc.destroy
    respond_to do |format|
      format.html { redirect_to user_docs_url, notice: "User document was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

    def user_docoments_type
      @super_user = User.find_by(role: "Super User")
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user_doc
      @user_doc = UserDoc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_doc_params
      params.require(:user_doc).permit(:doc_type, :description, :attachment, :document_type_id)
    end
end
