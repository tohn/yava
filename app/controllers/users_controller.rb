# UsersController
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :email]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page]).where("permission_id != ?", User::PERMISSIONS_DEACTIVATED)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #@users.
    @products = Product.paginate(:page => params[:page], per_page: 10).select(:id, :name).where("user_id = ?", @user.id)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  # FIXME This will never be executed, since a new user gets created in the model!
  def create
    @user = User.new(user_params)
	#@user.provider_id = Provider.find_by_name(params[:user][:provider_id].capitalize)
	#@user.provider_id = 
	@user.permission_id = User::PERMISSIONS_NONE
	@user.points = User::POINTS_INITIAL
	@user.lastlogin = DateTime.current
	@user.lastaction = DateTime.current
	@user.email_verified = false

    respond_to do |format|
      if @user.save
	# Tell the YavaMailer to send a welcome Email after save
	if !@user.email.include?"@change.me"
#	  logger.debug "mail! :)"
	  YavaMailer.welcome_email(@user, gen_hash(gen_salt)).deliver
	end
        format.html { redirect_to @user, notice: t("controller.created", model: t("activerecord.models.user")) }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
	@mail_old = @user.email
	@mail_new = params[:user][:email]
    respond_to do |format|
      if @user.update(user_params)
		if @mail_new != @mail_old
			@user.update(email_verified: false)
			YavaMailer.changed_email_address_email(@user, gen_hash(gen_salt)).deliver
		end
        format.html { redirect_to @user, notice: t("controller.updated", model: t("activerecord.models.user")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
	# destroy session first
	session[:user_id] = nil if session[:user_id]
    #@user.destroy
	uid = @user.uid.to_s+"d"
	@user.update(name: "D. Eleted", nickname: "deleted-"+@user.id.to_s, email: "deleted-"+@user.id.to_s+"@example.org", uid: uid, permission_id: User::PERMISSIONS_DEACTIVATED, email_verified: false)
	# TODO email with activation infos?
    respond_to do |format|
      format.html { redirect_to users_url, notice: t("controller.destroyed", model: t("activerecord.models.user")) }
      format.json { head :no_content }
    end
  end

  # E-Mail change
  # Trigger, if an user changes the mailaddress
  def email
    res = get_salt
    if !res.blank?
      if params[:hash] == gen_hash(res.salt)
	@user.update(email_verified: true)
	update_points(User::POINTS_EMAIL)
	# delete entry
	res.destroy
	redirect_to @user, notice: t(:users_email_verified)
      else
	# Not the same as in the database
	redirect_to @user, alert: t(:users_email_not_verified)
      end
    else
      # Too old
      redirect_to @user, alert: t(:users_email_not_verified)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id].to_i)
      if @user.blank?
	redirect_to users_path, alert: t("controller.notfound", model: t("activerecord.models.user"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :nickname, :email, :email_verified, :anonymize_name, :provider_id, :uid, :lastaction, :permission_id)
    end

    # generate a salt and save it in the database and return the salt
    #
    # NOTE: if you change this, also change the method in sessions_controller!
    def gen_salt
      salt = Digest::SHA3.hexdigest(DateTime.current.to_s + SecureRandom.hex(21+rand(21)).to_s, 256)
      Emailhash.new(user_id: @user.id, salt: salt).save
      salt
    end

    # generate an hash (defined through a salt)
    #
    # NOTE: if you change this, also change the method in sessions_controller!
    def gen_hash(salt)
      Digest::SHA3.hexdigest(@user.nickname.to_s + @user.email.to_s + @user.created_at.to_s + salt.to_s, 256)
    end

    # get the salt of an user and validate it (not older than 3 days)
    def get_salt
      res = Emailhash.select(:id, :salt, :created_at).where("user_id = ?", @user.id).last
      if !res.blank?
	dat = res.created_at.to_time.to_i
	now = Time.current.to_i
	# dat + 3 days
	if (dat+259200) < now
	  res
	else
	  # delete entry
	  res.destroy
	end
      end
    end

    # update the points of an user
    def update_points(point)
      @user.update_points(point)
    end

end