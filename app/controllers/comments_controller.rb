# CommentsController
class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.paginate(:page => params[:page])
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    # override param
    params[:comment][:user_id] = current_user.id
    
    respond_to do |format|
      if @comment.user.check_lastaction
	if @comment.save
	  # trigger veganity
	  trigger_create
	  # update_points
	  @comment.user.update_points(User::POINTS_COMMENT)
	  # update lastaction
	  @comment.user.update_lastaction
	  
	  format.html { redirect_to @comment, notice: t("controller.created", model: t("activerecord.models.comment")) }
	  format.js   {}
	  format.json { render action: 'show', status: :created, location: @comment }
	else
	  format.html { render action: 'new' }
	  format.js   {}
	  format.json { render json: @comment.errors, status: :unprocessable_entity }
	end
      else
	# http://stackoverflow.com/questions/5320934/how-to-add-custom-errors-to-the-user-errors-collection
	@comment.errors[:base] << t(:users_lastaction_wait)+@comment.user.get_lastaction_difference.to_s
	format.html { render action: "new" }
	format.js   {}
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
#   def update
#     respond_to do |format|
#       if @comment.update(comment_params)
#         format.html { redirect_to @comment, notice: t("controller.updated", model: t("activerecord.models.comment")) }
#         format.json { head :no_content }
#       else
#         format.html { render action: 'edit' }
#         format.json { render json: @comment.errors, status: :unprocessable_entity }
#       end
#     end
#   end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    #if @comment.user.check_lastaction
      @comment.user.update_lastaction
      @comment.destroy
      trigger_destroy
      respond_to do |format|
	format.html { redirect_to comments_url }
	format.js   {}
	format.json { head :no_content }
      end
#     else
#       respond_to do |format|
# 	format.html {}
# 	format.js   {}
#       end
#     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by_id(params[:id].to_i)
      if @comment.blank?
	redirect_to comments_path, alert: t("controller.notfound", model: t("activerecord.models.comment"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:comment, :user_id, :veganity_id, :product_id, :comment_id)
    end

	# trigger stuff after create
	def trigger_create
		@comment.product.update(veganity_comments_id: params[:comment][:veganity_id].to_i)
		#Product.find(params[:comment][:product_id]).update(:veganity_comments_id => params[:comment][:veganity_id])
		# update overall veganity of the product
		#@comment.product.update(veganity_id: @comment.product.update_veganity)
		
		# update the veganity of a product if it's an ingredient (compute overall veganity of this ingredient)
		if @comment.product.ingredient.count == 1
			# update veganity of the ingredient
			@comment.product.ingredient.first.update_veganity
		end
	end

	# trigger stuff after destroy
	def trigger_destroy
		@pid = Product.find(@comment.product_id)
		# if there is no comment anymore
		if !@pid.comments.any?
			@v = Veganity.find(Veganity::UNKNOWN)
		else
			# simply update the veganity equal to the last comment
			@v = Veganity.find(@pid.comments.order("created_at asc").last.veganity_id)
		end
		@pid.update(:veganity_comments_id => @v.id)
		# update overall veganity of the product
		#@comment.product.update(veganity_id: @comment.product.update_veganity)
	end

end
