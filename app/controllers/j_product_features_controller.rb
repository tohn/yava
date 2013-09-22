# JProductFeaturesController
class JProductFeaturesController < ApplicationController
  before_action :set_j_product_feature, only: [:show, :edit, :update, :destroy]

  # GET /j_product_features
  # GET /j_product_features.json
  def index
    @j_product_features = JProductFeature.paginate(:page => params[:page])
  end

  # GET /j_product_features/1
  # GET /j_product_features/1.json
  def show
  end

  # GET /j_product_features/new
  def new
    @j_product_feature = JProductFeature.new
  end

  # GET /j_product_features/1/edit
  def edit
  end

  # POST /j_product_features
  # POST /j_product_features.json
  def create
    @j_product_feature = JProductFeature.new(j_product_feature_params)
    @j_product_feature.user_id = current_user.id

    respond_to do |format|
      if @j_product_feature.save
        format.html { redirect_to @j_product_feature, notice: t("controller.created", model: t("activerecord.models.j_product_feature")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @j_product_feature }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @j_product_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /j_product_features/1
  # PATCH/PUT /j_product_features/1.json
  def update
    respond_to do |format|
      if @j_product_feature.update(j_product_feature_params)
        format.html { redirect_to @j_product_feature, notice: t("controller.updated", model: t("activerecord.models.j_product_feature")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @j_product_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /j_product_features/1
  # DELETE /j_product_features/1.json
  def destroy
    @j_product_feature.destroy
    respond_to do |format|
      format.html { redirect_to j_product_features_url }
      format.js   {}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_j_product_feature
      @j_product_feature = JProductFeature.find_by_id(params[:id].to_i)
      if @j_product_feature.blank?
	redirect_to j_product_features_path, alert: t("controller.notfound", model: t("activerecord.models.j_product_feature"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def j_product_feature_params
      params.require(:j_product_feature).permit(:product_id, :feature_id, :user_id)
    end
end
