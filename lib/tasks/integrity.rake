# http://railscasts.com/episodes/66-custom-rake-tasks
namespace :integrity do
	desc "Update all veganities"
	task :update => :environment do
		Product.all.map do |p|
			p.update(integrity: p.update_integrity)
		end
	end
end
