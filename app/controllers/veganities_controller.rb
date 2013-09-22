# VeganitiesController
class VeganitiesController < ApplicationController
  before_action :set_veganity, only: [:show, :edit, :update, :destroy]

  # GET /veganities
  # GET /veganities.json
  def index
    @veganities = Veganity.paginate(:page => params[:page])
  end

  # GET /veganities/1
  # GET /veganities/1.json
  def show
  end

  # GET /veganities/new
  def new
    @veganity = Veganity.new
  end

  # GET /veganities/1/edit
  def edit
  end

  # POST /veganities
  # POST /veganities.json
  def create
    @veganity = Veganity.new(veganity_params)

    respond_to do |format|
      if @veganity.save
        format.html { redirect_to @veganity, notice: 'Veganity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @veganity }
      else
        format.html { render action: 'new' }
        format.json { render json: @veganity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /veganities/1
  # PATCH/PUT /veganities/1.json
  def update
    respond_to do |format|
      if @veganity.update(veganity_params)
        format.html { redirect_to @veganity, notice: 'Veganity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @veganity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /veganities/1
  # DELETE /veganities/1.json
  def destroy
    @veganity.destroy
    respond_to do |format|
      format.html { redirect_to veganities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_veganity
      @veganity = Veganity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def veganity_params
      params.require(:veganity).permit(:name, :description, :image, :color)
    end
end
