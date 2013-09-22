# ProductsController
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.paginate(:page => params[:page], per_page: 15)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    # TODO: only if ?
    @product.update(veganity_id: @product.update_veganity)
    @n_fat = ["", ""]
    @n_saturated = ["", ""]
    @n_sugar = ["", ""]
    @n_natrium = ["", ""]
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    if !current_user
      redirect_to @product, alert: t("no_rights_signin_complete")
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params.except(:user_id, :ingredient, :label, :feature, :up_user_id))

	@product.user_id = current_user.id
	@product.veganity_ingredients_id = Veganity::UNKNOWN
	@product.veganity_inquiries_id = Veganity::UNKNOWN
	@product.veganity_comments_id = Veganity::UNKNOWN
	@product.veganity_id = Veganity::UNKNOWN

	# update integrity
	update_integrity
	@product.integrity = @integrity_new

    respond_to do |format|
      if @product.user.check_lastaction
      if @product.save
		# parse ingredients + update veganity
		parse_ings
		
		# update user (points)
		update_points(User::POINTS_NEW_PRODUCT)
		if @product.integrity == 100
		  update_points(User::POINTS_FINISHED_PRODUCT)
		end

		# update veganity of the product (total)
		# TODO: else (if source was deleted?)
		if !@product.source.blank?
		  @product.update(veganity_inquiries_id: @product.veganity_source_id)
		end
		
		# update lastaction of an user
		@product.user.update_lastaction

        format.html { redirect_to @product, notice: t("controller.created", model: t("activerecord.models.product")) }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
      else
	@product.errors[:base] << t(:users_lastaction_wait)+@product.user.get_lastaction_difference.to_s
	format.html { render action: "new" }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
	pid = params[:id]
	uid = current_user.id

	# update user
	params[:product][:up_user_id] = uid

	# integrity
	@old_integrity = params[:product][:integrity].to_i
	update_integrity
	params[:product][:integrity] = @integrity_new

    respond_to do |format|
#      if @product.user.check_lastaction
      if @product.update(product_params.except(:ingredient, :label, :feature, :user_id, :up_user_id))

	
	# update veganity of the product (total)
	if !@product.source.blank?
	  logger.debug "source"
	  if !@product.inquiries.any?
	    logger.debug "source 2"
	    @product.update(veganity_inquiries_id: @product.veganity_source_id)
	  end
	end
	
	# parse ingredients + update veganity
		parse_ings

		# update points?
		if @old_integrity != @integrity_new and @integrity_new == 100
			update_points(User::POINTS_FINISHED_PRODUCT)
		end
		
		# update lastaction of an user
		@product.user.update_lastaction

        format.html { redirect_to @product, notice: t("controller.updated", model: t("activerecord.models.product")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
#      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
#    if @product.user.check_lastaction
    # update lastaction of an user
    @product.user.update_lastaction
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
#    end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
		@product = Product.find_by_id(params[:id].to_i)
		if @product.blank?
			redirect_to products_path, alert: t("controller.notfound", model: t("activerecord.models.product"))
		end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
	def product_params
		params.require(:product).permit(:gtin, :image, :name, :description, :category_id, :packagematerial_id, :packagesize, :country_id, :brand_id, :source, :integrity, :user_id, :ingredients, :label, :feature, :up_user_id, :veganity_source_id, :nutval_id, :contains, :traces)
	end

	# parse the ingredients and update all associated stuff
	def parse_ings
		logger.debug product_params[:ingredients]
		if !product_params[:ingredients].blank?
			ings = parse_ingredients(product_params[:ingredients])
			pid = @product.id
			uid = current_user.id
			# parsed ingredients
			logger.debug ings
			arr = []
			if ings.size > 1
				ings.map do |i|
				  	# create if not already in the database
					if IngredientSynonym.where("lower(name) = ?", UnicodeUtils.downcase(i)).first.blank?
					  Ingredient.new(name: i, veganity_id: 
Veganity::UNKNOWN, user_id: uid, hide: false).save
					  # TODO: easier by using create?
					  ing = Ingredient.where("lower(name) = ?", UnicodeUtils.downcase(i)).first
					else
					  tmp = IngredientSynonym.where("lower(name) = ?", UnicodeUtils.downcase(i)).first.ingredient_id
					  ing = Ingredient.find_by_id(tmp)
					end

					# save all ingredient ids in an array to diff against all entries in the db
					if !ing.blank?
					  arr << ing.id
					
					  # save in joined table
					  JProductIngredient.new(:product_id => pid, :ingredient_id => ing.id, :user_id => uid).save
					end
				end

				# delete JIngredientProduct if present
				tmp = JIngredientProduct.where("product_id = ?", pid).first
				tmp.destroy if !tmp.blank?
			else
				Ingredient.new(name: ings.join(","), 
veganity_id: Veganity::UNKNOWN, user_id: uid, hide: false).save
				ing = Ingredient.where("lower(name) = ?", UnicodeUtils.downcase(ings.join(","))).first
				if !ing.blank?
				  arr << ing.id
				  JProductIngredient.new(:product_id => pid, :ingredient_id => ing.id, :user_id => uid).save
				  JIngredientProduct.new(:product_id => pid, :ingredient_id => ing.id, :user_id => uid).save
				end
			end
			# delete all old ingredients in the joint table
			tmp = JProductIngredient.select(:id, :ingredient_id).where("product_id = ?", pid).to_a
			arr2 = []
			tmp.each do |t|
				arr2 << t.ingredient_id
			end
			diff = arr2 - arr
			if diff.uniq.any?
				diff.uniq.map do |d|
					JProductIngredient.where("product_id = ? and ingredient_id = ?", pid, d).first.destroy
				end
			end

		end
	end

	# parse the ingredients
	#--
	# http://wowkhmer.com/2011/09/09/use-view-helper-methods-in-rails-3-controller/
	#++
	def parse_ingredients(ingredients)
	  ingredients.gsub!(/\*/, "")
	  ingredients.gsub!(/\°/, "")
	  ingredients.gsub!(/\r\n/, ",")
	  # TODO: s/rm_umlaute(Classname)//g
	  ingredients.gsub!(/(unter)\s+(schutzatmosphäre|schutzatmosphaere)\s+(verpackt)\s*(\.)*/i, "")
	  ingredients.gsub!(/(\(|\[|\]|\)|\s+(und)\s+|\s+\-\s+|\+|\;|\:|\.$)/i, ",")
	  ingredients.gsub!(/\d*(\,|\.)?\d+\s*\%/, ",")
	  # TODO: improve (landbau etc)
	  ingredients.gsub!(/\=?\W*(aus)?\W*(kontrolliert)?\p{L}*\W*(\p{L}*\W*){0,2}(anbau|landbau|landwirtschaft|erzeugung)/i, ",")
	  if ingredients.split(",").size > 1
	    arr = []
	    ingredients.split(",").each do |a|
	      # better: http://ruby-doc.org/core-2.0/Array.html#method-i-compact
	      if !a.strip.empty?
		# check for classnames (if it's a classname, don't use it)
		if !Classname.contains_this(a.strip)
		  # remove dots at the end, transform "E 100 a" into "E100a"
		  arr << view_context.rm_umlaute(a.strip.gsub(/\.\z/, "").gsub(/\b(e)\s*(\d{3,4})\s*(\w)?/i, 'E\2\3'))
		end
	      end
	    end
	    # TODO arr.uniq / arr.uniq!
	    return arr.uniq
	  else
	    # remove dots at the end, transform "E 100 a" into "E100a"
	    arr = []
	    ingredients.split(",").each do |a|
	      arr << view_context.rm_umlaute(a.strip.gsub(/\.\z/, "").gsub(/\b(e)\s*(\d{3,4})\s*(\w)?/i, 'E\2\3'))
	    end
	    return arr
	  end
	end

	# update points
	def update_points(point)
		@user = User.find(@product.user_id)
		@user.update_points(point)
	end

	# compute the integrity of the product
# 	def compute_integrity
# 		@counter = 0
# 		product_params.each do |p|
# 			if p[0] != "integrity" and p[0] != "user_id" and p[0] != "up_user_id" and p[0] != "nutval_id" and p[0] != "label" and p[0] != "source" and p[0] != "feature" and p[0] != "contains" and p[0] != "traces" and p[0] != "image"
# 				if !p[1].blank?
# 					@counter += 1
# 				end
# 			end
# 		end
# 		@integrity_new = (@counter/10.0*100).to_i
# 	end
	
	# Updates the integrity
	#--
	# NOTE: see model: product
	#++
	def update_integrity
	  @counter = 0
	  @border = 100
	  @quantity = 9.0
	  
	  @rejects = ["id", "image", "created_at", "updated_at", "integrity", 
"user_id", "up_user_id", "nutval_id", "label", "source", "feature", "contains", 
"traces", "veganity_ingredients_id", "veganity_inquiries_id", 
"veganity_comments_id", "veganity_source_id", "veganity_id", "image_file_name", 
"image_content_type", "image_file_size", "image_updated_at"]
	  @attributes = product_params.reject { |c| @rejects.include?(c) }
	  @attributes.each_pair do |x,y|
	    if !y.blank?
	      @counter += 1
	    end
	  end
	  # compute integrity
	  @integrity_new = (@counter/@quantity*@border).to_i
	  # fix integrity
	  @integrity_new = @border if @integrity_new > @border
	  # return integrity
	  @integrity_new
	end

end
