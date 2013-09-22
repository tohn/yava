# http://railscasts.com/episodes/66-custom-rake-tasks
namespace :veganity do
  desc "Update all veganities"
  task :update => :environment do
	#puts ""
	#puts " ### Products ### "
	#puts ""
	Product.all.map do |p|
		# TODO: only if ? or always?
		#puts p.name
		p.update(veganity_id: p.update_veganity)
	end
	# update all non fixed ingredients
	# TODO with at least one product
	#puts ""
	#puts " ### Ingredients ### "
	#puts ""
	Ingredient.where("not fixed and not hide").map do |i|
		#puts i.name
		i.update(veganity_id: i.update_veganity)
	end
	#Product.all.map do |p|
	#	# TODO: only if ? or always?
	#	p.update(veganity_id: p.update_veganity)
	#end
  end
end
