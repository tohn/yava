# README

This README documents which steps are necessary to get this
application called "YAVA: Yet Another Vegan App" up and running.

## System dependencies

You only need a few packages, which should normally ship with your
preferred distribution.

In this case, full support is only given for
[ArchLinux][] and we assume, that the operating
system is already up and running.

## Setup

This will explain the setup of the database, in this case PostgreSQL,
the website, here Ruby on Rails and a mobile App, where we will use
PhoneGap.

Please install these dependencies first:

* Ruby >= 2.0.0
* Node.js >= 0.10.17
* PostgreSQL >= 9.2.4

Next, we will setup a new user, to secure the system a litte bit:

	# useradd ror -d /path/to/yava
	# passwd ror
	# su ror

Then we will clone yava:

	git clone git@github.com:tohn/yava.git

And add the following two lines to the <code>~/.bashrc</code>:

	export PATH="/path/to/yava/.gem/ruby/2.0.0/bin:$PATH"
	export RAILS_ENV=production

and load them via:

	source ~/.bashrc

### Database

After installation of the package, you can create an user.
First, become the postgres user:

	sudo -i -u postgres

Create a new user, in this case `ror`:

	createuser -s -U ror

Leave this user again with `exit` and create a new database with
the normal ror-user:

	createdb yava_prod

### Website

Since you have (hopefully) already downloaded this project with git or
something else, you can install all stuff necessary to run the website
with just two commands:

	gem install bundle
	bundle install

Next we have to set some config variables:

	echo "Yava::Application.config.secret_key_base = '" > config/initializers/secret_token.rb
	rake secret >> config/initializers/secret_token.rb
	echo "'" >> config/initializers/secret_token.rb

Afterwards, change the file <code>config/local_env.yml</code>.
There you can set some settings like mail addresses and authentication
for them and choose between Omniauth providers like Google (you have to
create an app first) or Htaccess.

	$EDITOR config/local_env.yml

In case of Omniauth, there are no further steps required (except for
adding the key and secret for each provider in the above file).

In case of Htaccess, change <code>USERNAME</code> and <code>PASSWORD</code>
in this file and uncomment this line in
<code>app/controllers/application_controller.rb</code>:

	before_filter :authenticate

This will use Htaccess and the default user (in <code>db/seeds.rb</code>).

For the database, you have to edit <code>config/database.yml</code>
and change all occurences of username to your username, i.e. ror.

Next, open <code>config/environments/production.rb</code> and change
the mail settings at the end of the file.

Then precompile the assets:

	rails generate jquery:install
	rake assets:precompile

Next, create the database, migrate the migrations in
<code>db/migrations</code> and initialize the database with the data
from <code>db/seeds.rb</code>:

	rake db:create db:migrate db:seed

And finally, start the server:

	rails s

#### I18n/L10n

If you want to use another language than the default one (german), you
have to change the following files:

* <code>config/application.rb</code>
* <code>app/views/yava_mailer/</code>
* <code>app/views/home/</code>

Also copy <code>config/locales/de.yml</code> and
<code>config/locales/simple_form.de.yml</code> and adjust them.

#### Mail

To send mails, you have to change the settings in
<code>config/environments/production.rb</code>. You can also choose a
mail host without authentication, then uncomment the
<code>delivery_options</code> lines in
<code>app/mailers/yava_mailer.rb</code> and set at least
<code>YAVA_EMAIL</code> and <code>INQUIRY_EMAIL</code> in
<code>config/local_env.yml</code>.

#### Mailserver

If you have a mailserver installed and running, you can use it to
receive mails and save them automatically in the database. This is
useful for ingoing responses from the manufacturers.

You can pipe the mails like this:

	cat testmail | /path/to/yava/bin/rails runner "YavaMailer.receive(STDIN.read)"

#### Cronjobs

To provide up to date veganities and a daily dump of your database,
you can set up a cronjob.

As ror-User:

	crontab -e

then insert:

	# http://stackoverflow.com/questions/285717/a-cron-job-for-rails-best-practices
	@hourly cd /path/to/yava && RAILS_ENV=production rake veganity:update --silent
	@daily /path/to/yava/db/dump_postgresql_db.sh

### Mobile application

The app can be found [here][].

You just have to change the URL to get it running with the newly
created website described above, by changing <code>rooturl</code>
in <code>www/js/index.js</code>.

## Documentation

To generate the documentation for YAVA, run:

	yardoc --no-private --protected app/**/*.rb - README.md

If you just want to create this file, run:

	yardoc --no-private --protected - README.md

Then, open <code>/path/to/yava/doc/index.html</code> in your browser.

[ArchLinux]: https://archlinux.org
[here]: https://github.com/tohn/yamva
