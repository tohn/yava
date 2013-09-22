# ManufacturersController
class ManufacturersController < ApplicationController
  before_action :set_manufacturer, only: [:show, :edit, :update, :destroy]

  # GET /manufacturers
  # GET /manufacturers.json
  def index
    @manufacturers = Manufacturer.paginate(:page => params[:page])
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.json
  def show
  end

  # GET /manufacturers/new
  def new
    @manufacturer = Manufacturer.new
  end

  # GET /manufacturers/1/edit
  def edit
    if !current_user
      redirect_to @manufacturer, alert: t("no_rights_signin_complete")
    end
  end

  # POST /manufacturers
  # POST /manufacturers.json
  def create
    @manufacturer = Manufacturer.new(manufacturer_params)
    @manufacturer.user_id = current_user.id

    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to @manufacturer, notice: t("controller.created", model: t("activerecord.models.manufacturer")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @manufacturer }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manufacturers/1
  # PATCH/PUT /manufacturers/1.json
  def update
    respond_to do |format|
      if @manufacturer.update(manufacturer_params)
        format.html { redirect_to @manufacturer, notice: t("controller.updated", model: t("activerecord.models.manufacturer")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.json
  def destroy
    @manufacturer.destroy
    respond_to do |format|
      format.html { redirect_to manufacturers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manufacturer
      @manufacturer = Manufacturer.find_by_id(params[:id].to_i)
      if @manufacturer.blank?
	redirect_to manufacturers_path, alert: t("controller.notfound", model: t("activerecord.models.manufacturer"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manufacturer_params
      params.require(:manufacturer).permit(:name, :street, :city_id, :http, :email, :tel, :fax, :image, :user_id)
    end
end
