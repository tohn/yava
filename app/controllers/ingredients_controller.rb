# IngredientsController
class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]

  # GET /ingredients
  # GET /ingredients.json
  def index
    @ingredients = Ingredient.where("not hide").paginate(:page => params[:page])
  end

  # GET /ingredients/1
  # GET /ingredients/1.json
  def show
    #@ingredient.update_veganity
    @ingredient.update(veganity_id: @ingredient.update_veganity)
  end

  # GET /ingredients/new
  def new
    @ingredient = Ingredient.new
  end

  # GET /ingredients/1/edit
  def edit
    if !current_user
      redirect_to @ingredient, alert: t("no_rights_signin_complete")
    end
  end

  # POST /ingredients
  # POST /ingredients.json
  def create
    @ingredient = Ingredient.new(ingredient_params)
    @ingredient.user_id = current_user.id
    # http://wowkhmer.com/2011/09/09/use-view-helper-methods-in-rails-3-controller/
    @ingredient.name = view_context.rm_umlaute(@ingredient.name)

    respond_to do |format|
      if @ingredient.save
        format.html { redirect_to @ingredient, notice: t("controller.created", model: t("activerecord.models.ingredient")) }
        format.json { render action: 'show', status: :created, location: @ingredient }
      else
        format.html { render action: 'new' }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingredients/1
  # PATCH/PUT /ingredients/1.json
  def update
    @veganity_old = @ingredient.veganity_id
    @veganity_new = ingredient_params[:veganity_id]
    # TODO: @ingredient.name = view_context.rm_umlaute(@ingredient.name)
    respond_to do |format|
      if @ingredient.update(ingredient_params)
         format.html { redirect_to @ingredient, notice: t("controller.updated", model: t("activerecord.models.ingredient")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.json
  def destroy
    @ingredient.destroy
    respond_to do |format|
      format.html { redirect_to ingredients_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = Ingredient.find_by_id(params[:id].to_i)
      if @ingredient.blank?
	redirect_to ingredients_path, alert: t("controller.notfound", model: t("activerecord.models.ingredient"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ingredient_params
      params.require(:ingredient).permit(:name, :description, :veganity_id, :image, :source, :user_id, :classname_id, :hide, :fixed)
    end

end
