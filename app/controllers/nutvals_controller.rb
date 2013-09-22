# NutvalsController
class NutvalsController < ApplicationController
  before_action :set_nutval, only: [:show, :edit, :update, :destroy]

  # GET /nutvals
  # GET /nutvals.json
  def index
    @nutvals = Nutval.paginate(:page => params[:page])
  end

  # GET /nutvals/1
  # GET /nutvals/1.json
  def show
  end

  # GET /nutvals/new
  def new
    @nutval = Nutval.new
  end

  # GET /nutvals/1/edit
  def edit
  end

  # POST /nutvals
  # POST /nutvals.json
  def create
    @nutval = Nutval.new(nutval_params)
    @nutval.user_id = current_user.id
    respond_to do |format|
      if @nutval.save
        format.html { redirect_to @nutval, notice: t("controller.created", model: t("activerecord.models.nutval")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @nutval }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @nutval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nutvals/1
  # PATCH/PUT /nutvals/1.json
  def update
    respond_to do |format|
      if @nutval.update(nutval_params)
        format.html { redirect_to @nutval, notice: t("controller.updated", model: t("activerecord.models.nutval")) }
	format.js   {}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
	format.js   {}
        format.json { render json: @nutval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nutvals/1
  # DELETE /nutvals/1.json
  def destroy
    @nutval.destroy
    respond_to do |format|
      format.html { redirect_to nutvals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nutval
      @nutval = Nutval.find_by_id(params[:id].to_i)
      if @nutval.blank?
	redirect_to nutvals_path, alert: t("controller.notfound", model: t("activerecord.models.nutval"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nutval_params
      params.require(:nutval).permit(:energy, :proteins, :carbohydrates, :sugar, :fat, :saturated, :monounsaturated, :polyunsaturated, :roughages, :natrium, :alcohol, :user_id)
    end

end
