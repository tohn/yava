# ProductsHelper
module ProductsHelper
  
  # returns a Veganity as name
  def get_veganity(vegan)
    Veganity.find_by_id(vegan).name.capitalize
  end
  
  # This will join stuff given as parameter
  def join_stuff(what, path, html=true)
    if !what.blank?
      if html
	what.map do |w|
	  # http://railsforum.com/viewtopic.php?id=26651
	  link_to w.name, eval("#{path}_path(w.id)")
	  #					link_to w.name, polymorphic_path(w.id)
	end.join(", ").html_safe
      else
	what.map do |w|
	  w.name
	end.join(", ")
      end
    else
      ""
    end
  end
  
  # This will join labels
  def join_labels(what, path)
    if !what.blank?
      what.map do |w|
	link_to(image_tag(w.image(:thumb), class: "img-polaroid"), label_path(w.id))
      end.join(" ").html_safe
    end
  end
  
  # Returns a Brand (with link)
  def get_brand(brand)
    if !brand.blank?
      link_to brand.name, brand_path(brand.id)
    end
  end
  
  # Returns a Manufacturer (with link)
  def get_manufacturer(brand)
    if !brand.blank? and !brand.manufacturer.blank?
      link_to(brand.manufacturer.name, manufacturer_path(brand.manufacturer.id))
    end
  end
  
  # Cleans a nutval
  def clean_nutval(val)
    if !val.blank?
      if val.is_a?(Float)
        val
      else
        val.strip.gsub(/^\D*(\d+)(.|,)?(\d?)\D*$/, '\1.\3').to_f
      end
    end
  end
  
  # Returns GDA value in percent
  def get_gda(val, border)
    tmp = clean_nutval(val)
    res = (tmp/border*100)
    if res > 0.0 and res < 1.0
      "<1 %"
    else
      res.round.to_s+" %"
    end
  end
  
  # Returns a Nutval rating
  def get_nutval_rating(val, min, max)
    # only digits and float
    tmp = clean_nutval(val)
    if !tmp.blank?
      if tmp < min
	["success", t(:nutval_rating_low)]
      elsif tmp > max
	["error", t(:nutval_rating_high)]
      else
	["warning", t(:nutval_rating_medium)]
      end
    else
      ""
    end
  end
  
  # TODO: move to application?
  def show_url(name, url)
    if !url.blank?
      # TODO: open in new window?
      # check if http/https 
      if url.include? "http"
	link_to name, url
      else
	link_to name, "http://#{url}"
      end
    end
  end
  
  # generates an image out of a barcode
  def print_barcode(barcode)
    # use barby
  end
  
end
