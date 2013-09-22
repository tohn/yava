# JIngredientClassnamesController
class JIngredientClassnamesController < ApplicationController
  before_action :set_j_ingredient_classname, only: [:show, :edit, :update, :destroy]

  # GET /j_ingredient_classnames
  # GET /j_ingredient_classnames.json
  def index
    @j_ingredient_classnames = JIngredientClassname.paginate(:page => params[:page])
  end

  # GET /j_ingredient_classnames/1
  # GET /j_ingredient_classnames/1.json
  def show
  end

  # GET /j_ingredient_classnames/new
  def new
    @j_ingredient_classname = JIngredientClassname.new
  end

  # GET /j_ingredient_classnames/1/edit
  def edit
  end

  # POST /j_ingredient_classnames
  # POST /j_ingredient_classnames.json
  def create
    @j_ingredient_classname = JIngredientClassname.new(j_ingredient_classname_params)

    respond_to do |format|
      if @j_ingredient_classname.save
        format.html { redirect_to @j_ingredient_classname, notice: t("controller.created", model: t("activerecord.models.j_ingredient_classname")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @j_ingredient_classname }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @j_ingredient_classname.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /j_ingredient_classnames/1
  # PATCH/PUT /j_ingredient_classnames/1.json
  def update
    respond_to do |format|
      if @j_ingredient_classname.update(j_ingredient_classname_params)
        format.html { redirect_to @j_ingredient_classname, notice: t("controller.updated", model: t("activerecord.models.j_ingredient_classname")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @j_ingredient_classname.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /j_ingredient_classnames/1
  # DELETE /j_ingredient_classnames/1.json
  def destroy
    @j_ingredient_classname.destroy
    respond_to do |format|
      format.html { redirect_to j_ingredient_classnames_url }
      format.js   {}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_j_ingredient_classname
      @j_ingredient_classname = JIngredientClassname.find_by_id(params[:id].to_i)
      if @j_ingredient_classname.blank?
	redirect_to j_ingredient_classnames_path, alert: t("controller.notfound", model: t("activerecord.models.j_ingredient_classname"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def j_ingredient_classname_params
      params.require(:j_ingredient_classname).permit(:ingredient_id, :classname_id)
    end
end
