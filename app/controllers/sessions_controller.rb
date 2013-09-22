# SessionsController
class SessionsController < ApplicationController
  
  # currently does nothing
  def new
  end

  # this will create a new user or sign an user in (and write a welcome_email, if there is one)
  def create
    auth = request.env["omniauth.auth"]
    if !auth.blank?
      user = User.from_omniauth(auth)
      # if user.blank?
      # 	http://stackoverflow.com/questions/5599698/rails-passing-parameters-in-a-redirect-to-is-session-the-only-way
      # 	redirect_to(new_user_path(auth: request.env["omniauth.auth"]))
      # else
      session[:user_id] = user.id
      if current_user
	# send only on user creation, not on each login
	if !current_user.email.include?"@change.me" and !current_user.first_mail
	  logger.debug "mail! :)"
	  YavaMailer.welcome_email(current_user, gen_hash(gen_salt)).deliver
	  current_user.update(first_mail: true)
	end
	redirect_to user_path(current_user), notice: t(:session_create_success)
      else
	redirect_to root_path, alert: t(:session_create_failure)
      end
      # end
    else
      redirect_to root_path, alert: t(:session_create_failure)
    end
  end

  # destroy an user's session
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t(:session_destroy)
  end

  # something went wrong
  def failure
    redirect_to root_path, alert: t(:session_failure)
  end
  
  # generate a salt and save it in the database and return the salt
  #
  # NOTE: if you change this, also change the method in users_controller!
  def gen_salt
    salt = Digest::SHA3.hexdigest(DateTime.current.to_s + SecureRandom.hex(21+rand(21)).to_s, 256)
    Emailhash.new(user_id: current_user.id, salt: salt).save
    salt
  end
  
  # generate an hash (defined through a salt)
  #
  # NOTE: if you change this, also change the method in users_controller!
  def gen_hash(salt)
    Digest::SHA3.hexdigest(current_user.nickname.to_s + current_user.email.to_s + current_user.created_at.to_s + salt.to_s, 256)
  end
  
end
