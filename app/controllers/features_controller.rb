# FeaturesController
class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :destroy]

  # GET /features
  # GET /features.json
  def index
    @features = Feature.paginate(:page => params[:page])
  end

  # GET /features/1
  # GET /features/1.json
  def show
  end

  # GET /features/new
  def new
    @feature = Feature.new
  end

  # GET /features/1/edit
  def edit
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.new(feature_params)
    @feature.user_id = current_user.id

    respond_to do |format|
      if @feature.save
        format.html { redirect_to @feature, notice: t("controller.created", model: t("activerecord.models.feature")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @feature }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /features/1
  # PATCH/PUT /features/1.json
  def update
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to @feature, notice: t("controller.updated", model: t("activerecord.models.feature")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature.destroy
    respond_to do |format|
      format.html { redirect_to features_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find_by_id(params[:id].to_i)
      if @feature.blank?
	redirect_to features_path, alert: t("controller.notfound", model: t("activerecord.models.feature"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:name, :description)
    end
end
