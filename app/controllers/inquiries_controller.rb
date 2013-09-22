# InquiriesController
class InquiriesController < ApplicationController
  before_action :set_inquiry, only: [:show, :edit, :update, :destroy]

  # GET /inquiries
  # GET /inquiries.json
  def index
    @inquiries = Inquiry.paginate(:page => params[:page])
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
  end

  # GET /inquiries/new
  def new
    @inquiry = Inquiry.new
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries
  # POST /inquiries.json
  def create
    @inquiry = Inquiry.new(inquiry_params)
	#params[:inquiry][:user_id] = current_user.id
	# http://stackoverflow.com/questions/1465569/ruby-how-can-i-copy-a-variable-without-pointing-to-the-same-object
	@inquiry_orig = @inquiry.dup
	@user = User.where("id = ?", params[:inquiry][:user_id]).first
	#logger.debug @user.name
	@inquiry.typ = false
	@inquiry.highlight = false
	@inquiry.veganity_id = Veganity::UNKNOWN
	@inquiry.seen = true
	
	# anonymize name?
	# please edit also products/_inquiry_hint.text.erb!
	if @user.anonymize_name
	  @inquiry.text.strip!
	  @inquiry.text.gsub!(@user.name, "XYZ")
	end
	@inquiry_orig.text.strip! # += render "yava_mailer/pa_desc.html.erb"
	@inquiry_orig.text += t(:inquiry_hint_text_1)+url_for(action: :index, controller: :home, only_path: false)+t(:inquiry_hint_text_2)
	#params[:inquiry][:text] = params[:inquiry][:text] % @user.anonymize_name ? "XYZ" : @user.name
	respond_to do |format|
	  if @inquiry.user.check_lastaction
	    if @inquiry.save
	      trigger_create
	      # send mail!
	      YavaMailer.inquiry_email(params[:inquiry][:product_id].to_i, @inquiry_orig).deliver
	      
	      format.html { redirect_to @inquiry, notice: t("controller.created", model: t("activerecord.models.inquiry")) }
	      format.js   {}
	      format.json { render action: 'show', status: :created, location: @inquiry }
	    else
	      format.html { render action: 'new' }
	      format.js   {}
	      format.json { render json: @inquiry.errors, status: :unprocessable_entity }
	    end
	  else
	    @inquiry.errors[:base] << t(:users_lastaction_wait)+@inquiry.user.get_lastaction_difference.to_s
	    format.html { render action: "new" }
	    format.js   {}
	  end
	end
  end

  # This will create an inquiry (and is a response from the
  # manufacturer)
  def create2
	@inquiry = Inquiry.new(inquiry_params)
	respond_to do |format|
	  if @inquiry.user.check_lastaction
		if @inquiry.save
			trigger_create2
			format.html { redirect_to product_path(@inquiry.product_id), notice: t("controller.created", model: t("activerecord.models.inquiry")) }
			format.json { render action: "show", status: :created, location: @inquiry.product_id }
		else
			format.html { render action: "new" }
			format.json { render json: @inquiry.errors, status: :unprocessable_entity }
		end
	  else
	    @inquiry.errors[:base] << t(:users_lastaction_wait)+@inquiry.user.get_lastaction_difference.to_s
	    format.html { render action: "new" }
	    format.js   {}
	  end
	end
  end

  # PATCH/PUT /inquiries/1
  # PATCH/PUT /inquiries/1.json
  def update
    respond_to do |format|
#      if @inquiry.user.check_lastaction
	if @inquiry.update(inquiry_params)
	  trigger_create
	  format.html { redirect_to product_path(@inquiry.product_id), notice: t("controller.updated", model: t("activerecord.models.inquiry")) }
	  format.json { head :no_content }
	else
	  format.html { render action: 'edit' }
	  format.json { render json: @inquiry.errors, status: :unprocessable_entity }
	end
#       else
# 	@inquiry.errors[:base] << t(:users_lastaction_wait)+@inquiry.user.get_lastaction_difference.to_s
# 	format.html { render action: "edit" }
# 	format.js   {}
#       end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  def destroy
    #if @inquiry.user.check_lastaction
    @inquiry.user.update_lastaction
    @inquiry.destroy
    trigger_destroy
    respond_to do |format|
      format.html { redirect_to inquiries_url }
      format.js   {}
      format.json { head :no_content }
    end
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inquiry
      @inquiry = Inquiry.find_by_id(params[:id].to_i)
      if @inquiry.blank?
	redirect_to inquiries_path, alert: t("controller.notfound", model: t("activerecord.models.inquiry"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inquiry_params
      params.require(:inquiry).permit(:typ, :text, :user_id, :highlight, :veganity_id, :product_id, :seen)
    end

	# trigger stuff after create (via product)
	def trigger_create
		@inquiry.product.update(veganity_inquiries_id: Veganity::UNKNOWN)

		@inquiry.user.update_points(User::POINTS_NEW_INQUIRY)

		# update overall veganity of the product, but not all
		# associated products/ingredients, because the veganity is
		# always unknown (= 4).
		#@inquiry.product.update(veganity_id: @inquiry.product.update_veganity)
		
		@inquiry.user.update_lastaction
	end

	# trigger stuff after create2 (via copy/paste link in users)
	def trigger_create2
	  @inquiry.product.update(veganity_inquiries_id: params[:inquiry][:veganity_id].to_i)
	  
	  @inquiry.user.update_points(User::POINTS_FINISHED_INQUIRY)
	  
	  @inquiry.user.update_lastaction
	  
	  # if the product has only one ingredient, update the overall
	  # veganity of the ingredient
	  if @inquiry.product.ingredient.count == 1
	    @inquiry.product.ingredient.first.update_veganity
	  end
	end

	# trigger stuff after destroy
	def trigger_destroy
		@pid = Product.find(@inquiry.product_id)
		# if there is no inquiry anymore
		if !@pid.inquiries.any?
			@v = !@pid.source.blank? ? @pid.veganity_source_id : Veganity.find(Veganity::UNKNOWN)
		else
			# simply update the veganity equal to the last inquiry
			@v = Veganity.find(@pid.inquiries.order("created_at asc").last.veganity_id)
		end
		@pid.update(veganity_inquiries_id: @v.id)
	end

end
