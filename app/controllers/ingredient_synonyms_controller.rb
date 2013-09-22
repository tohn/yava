# IngredientSynonymsController
class IngredientSynonymsController < ApplicationController
  before_action :set_ingredient_synonym, only: [:show, :edit, :update, :destroy]

  # GET /ingredient_synonyms
  # GET /ingredient_synonyms.json
  def index
    @ingredient_synonyms = IngredientSynonym.paginate(:page => params[:page])
  end

  # GET /ingredient_synonyms/1
  # GET /ingredient_synonyms/1.json
  def show
  end

  # GET /ingredient_synonyms/new
  def new
    @ingredient_synonym = IngredientSynonym.new
  end

  # GET /ingredient_synonyms/1/edit
  def edit
  end

  # POST /ingredient_synonyms
  # POST /ingredient_synonyms.json
  def create
    @ingredient_synonym = IngredientSynonym.new(ingredient_synonym_params)

    respond_to do |format|
      if @ingredient_synonym.save
        format.html { redirect_to @ingredient_synonym, notice: t("controller.created", model: t("activerecord.models.ingredient_synonym")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @ingredient_synonym }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @ingredient_synonym.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingredient_synonyms/1
  # PATCH/PUT /ingredient_synonyms/1.json
  def update
    respond_to do |format|
      if @ingredient_synonym.update(ingredient_synonym_params)
        format.html { redirect_to @ingredient_synonym, notice: t("controller.updated", model: t("activerecord.models.ingredient_synonym")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ingredient_synonym.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredient_synonyms/1
  # DELETE /ingredient_synonyms/1.json
  def destroy
    @ingredient_synonym.destroy
    respond_to do |format|
      format.html { redirect_to ingredient_synonyms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient_synonym
      @ingredient_synonym = IngredientSynonym.find_by_id(params[:id].to_i)
      if @ingredient_synonym.blank?
	redirect_to ingredient_synonyms_path, alert: t("controller.notfound", model: t("activerecord.models.ingredient_synonym"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ingredient_synonym_params
      params.require(:ingredient_synonym).permit(:name, :ingredient_id)
    end
end
