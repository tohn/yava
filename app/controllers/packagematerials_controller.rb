# PackagematerialsController
class PackagematerialsController < ApplicationController
  before_action :set_packagematerial, only: [:show, :edit, :update, :destroy]

  # GET /packagematerials
  # GET /packagematerials.json
  def index
    @packagematerials = Packagematerial.paginate(:page => params[:page])
  end

  # GET /packagematerials/1
  # GET /packagematerials/1.json
  def show
  end

  # GET /packagematerials/new
  def new
    @packagematerial = Packagematerial.new
  end

  # GET /packagematerials/1/edit
  def edit
  end

  # POST /packagematerials
  # POST /packagematerials.json
  def create
    @packagematerial = Packagematerial.new(packagematerial_params)
    @packagematerial.user_id = current_user.id
    respond_to do |format|
      if @packagematerial.save
        format.html { redirect_to @packagematerial, notice: t("controller.created", model: t("activerecord.models.packagematerial")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @packagematerial }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @packagematerial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packagematerials/1
  # PATCH/PUT /packagematerials/1.json
  def update
    respond_to do |format|
      if @packagematerial.update(packagematerial_params)
        format.html { redirect_to @packagematerial, notice: t("controller.updated", model: t("activerecord.models.packagematerial")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @packagematerial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packagematerials/1
  # DELETE /packagematerials/1.json
  def destroy
    @packagematerial.destroy
    respond_to do |format|
      format.html { redirect_to packagematerials_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_packagematerial
      @packagematerial = Packagematerial.find_by_id(params[:id].to_i)
      if @packagematerial.blank?
	redirect_to packagematerials_path, alert: t("controller.notfound", model: t("activerecord.models.packagematerial"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def packagematerial_params
      params.require(:packagematerial).permit(:name, :description, :http, :user_id, :image, :abbr, :code)
    end
end
