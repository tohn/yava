# LabelsController
class LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]

  # GET /labels
  # GET /labels.json
  def index
    @labels = Label.paginate(:page => params[:page])
  end

  # GET /labels/1
  # GET /labels/1.json
  def show
  end

  # GET /labels/new
  def new
    @label = Label.new
  end

  # GET /labels/1/edit
  def edit
  end

  # POST /labels
  # POST /labels.json
  def create
    @label = Label.new(label_params)
    @label.user_id = current_user.id

    respond_to do |format|
      if @label.save
        format.html { redirect_to @label, notice: t("controller.created", model: t("activerecord.models.label")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @label }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /labels/1
  # PATCH/PUT /labels/1.json
  def update
    respond_to do |format|
      if @label.update(label_params)
        format.html { redirect_to @label, notice: t("controller.updated", model: t("activerecord.models.label")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1
  # DELETE /labels/1.json
  def destroy
    @label.destroy
    respond_to do |format|
      format.html { redirect_to labels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_label
      @label = Label.find_by_id(params[:id].to_i)
      if @label.blank?
	redirect_to labels_path, alert: t("controller.notfound", model: t("activerecord.models.label"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def label_params
      params.require(:label).permit(:name, :feature_id, :image, :description, :source, :user_id)
    end
end
