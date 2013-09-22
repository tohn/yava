# BrandsController
class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  # GET /brands
  # GET /brands.json
  def index
    @brands = Brand.paginate(:page => params[:page])
  end

  # GET /brands/1
  # GET /brands/1.json
  def show
  end

  # GET /brands/new
  def new
    @brand = Brand.new
  end

  # GET /brands/1/edit
  def edit
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params)
    @brand.user_id = current_user.id

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, notice: t("controller.created", model: t("activerecord.models.brand")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @brand }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brands/1
  # PATCH/PUT /brands/1.json
  def update
    respond_to do |format|
      if @brand.update(brand_params)
        format.html { redirect_to @brand, notice: t("controller.updated", model: t("activerecord.models.brand")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  def destroy
    @brand.destroy
    respond_to do |format|
      format.html { redirect_to brands_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find_by_id(params[:id].to_i)
      if @brand.blank?
	redirect_to brands_path, alert: t("controller.notfound", model: t("activerecord.models.brand"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:brand).permit(:name, :manufacturer_id)
    end
end
