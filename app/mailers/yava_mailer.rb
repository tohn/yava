# YavaMailer
class YavaMailer < ActionMailer::Base
  default from: "#{ENV["TITLE_SHORT"]} <#{ENV["YAVA_EMAIL"]}>"

  # this will write a welcome mail to a new user
  def welcome_email(user, hash)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    delivery_options = { user_name: ENV["YAVA_USERNAME"], password: ENV["YAVA_PASSWORD"] }
    @loginurl = url_for(action: :index, controller: :home, only_path: false)
    @loginurl += "auth/" + UnicodeUtils.downcase(@user.provider.name)
    @hashurl = url_for(action: :email, controller: :users, id: @user.id, only_path: false)
    @hashurl += "?hash=" + hash
    mail(to: email_with_name, subject: t(:mailer_welcome_email))
  end

  # this will send a link to validate a new mailaddress, if the user has changed it
  def changed_email_address_email(user, hash)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    delivery_options = { user_name: ENV["YAVA_USERNAME"], password: ENV["YAVA_PASSWORD"] }
    @hashurl = url_for(action: :email, controller: :users, id: @user.id, only_path: false)
    @hashurl += "?hash=" + hash
    mail(to: email_with_name, subject: t(:mailer_email_change))
  end

  # this will send a inquiry to a manufacturer
  # FIXME: not at the moment, this will send you the mail instead
  def inquiry_email(product, inquiry)
    @p = Product.where("id = ?", product).first
    @i = inquiry
    @cc = "#{@p.user.name} <#{@p.user.email}>"
    @to = @p.brand.manufacturer.email
    @from = "#{t(:mailer_inquiry_email_from)} <#{ENV["INQUIRY_EMAIL"]}>"
    mail(to: @cc, from: @from, cc: @cc, reply_to: @cc, subject: "[#{@p.id}] #{t(:mailer_inquiry_email)} #{@p.name}", body: @i.text)
  end

  # if a mailserver is configured, insert a new pa with this method
  # i.e. execute:
  # cat EMAIL | /path/to/yava/bin/rails runner "YavaMailer.receive(STDIN.read)"
  def receive(email)
    inq = Inquiry.where("product_id = ?", email.subject.scan(/\d/).join).first
    if !inq.blank?
      Inquiry.new(:typ => true, :user_id => inq.user_id, :highlight => false, :veganity_id => Veganity::UNKNOWN, :product_id => inq.product_id, :text => email.body.raw_source, :seen => false).save
      # update user points
      @user = User.find(inq.user_id)
      @user.update_points(User::POINTS_FINISHED_INQUIRY)
    end
  end
end
