Rails.application.config.middleware.use OmniAuth::Builder do
	OmniAuth.config.logger = Rails.logger
	OmniAuth.logger.progname = "omniauth"
	OmniAuth.config.on_failure = SessionsController.action(:failure)
	# https://github.com/intridea/omniauth/wiki/FAQ
#	OmniAuth.config.on_failure = Proc.new { |env|
#	  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
#	}

	# omniauth docu:
	# http://railscasts.com/episodes/241-simple-omniauth
	# http://www.omniauth.org/
	# http://railscasts.com/episodes/304-omniauth-identity?view=asciicast
	# https://github.com/intridea/omniauth/wiki/_pages

	# https://github.com/arunagw/omniauth-twitter
	# https://dev.twitter.com/docs/auth/sign-twitter
	# https://dev.twitter.com/apps
	provider :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"], {
		:use_authorize => true
	}

	# https://code.google.com/apis/console/
	# https://github.com/zquestz/omniauth-google-oauth2
	# https://developers.google.com/accounts/docs/OAuth2Login
	## :scope => "userinfo.email,userinfo.profile,plus.login",
	provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"], {
		:scope => "userinfo.email,userinfo.profile",
		:approval_prompt => "auto"
	}

	# https://developers.facebook.com/apps
	# https://developers.facebook.com/docs/reference/dialogs/oauth/
	provider :facebook, ENV["FACEBOOK_KEY"], ENV["FACEBOOK_SECRET"], {
		:scope => "email"
	}

	# https://github.com/settings/applications/
	# https://github.com/intridea/omniauth-github
	# http://developer.github.com/v3/oauth/#scopes
	provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"], {
		:scope => "user:email",
		:redirect_uri => "http://localhost:3000/auth/github/callback",
		:state => "YAVA"
	}

	# https://github.com/Zeeraw/omniauth-deviantart
	# https://www.deviantart.com/settings/myapps
	#provider :deviantart, ENV["DEVIANTART_KEY"], ENV["DEVIANTART_SECRET"], {}

	# openid
	# https://github.com/intridea/omniauth-openid
	# http://openid.net/add-openid/
	#provider :openid, ENV["OPENID_KEY"], ENV["OPENID_SECRET"], {}
end
