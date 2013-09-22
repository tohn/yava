# IngredientsHelper
module IngredientsHelper

  # http://stackoverflow.com/questions/12005739/replace-umlauts-in-ruby-on-rails
  # 
  # this removes the umlaute from an ingredient and returns the "clean" ingredient
  def rm_umlaute(ingredient)
    ingredient.gsub!(/[äöüßÄÖÜ]/) do |match|
      case match
	when "ä" then "ae"
	when "ö" then "oe"
	when "ü" then "ue"
	when "ß" then "ss"
	when "Ä" then "Ae"
	when "Ö" then "Oe"
	when "Ü" then "Ue"
      end
    end
    ingredient
  end

end