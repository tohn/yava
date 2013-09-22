# HomeController
class HomeController < ApplicationController
protect_from_forgery :except => [:search, :msearch]

  # search via http
  def search
    @search = params[:search]
    if !@search.blank?
      @product = Product.select(:id).where("gtin = ? or lower(name) like ?", @search.to_i, "%"+UnicodeUtils.downcase(@search.to_s.downcase)+"%")
      # @products = Product.search(@search)
      if @product.any?
	if @product.size == 1
	  redirect_to product_path(@product.first)
	end
      end
    end
  end

  # mobile search (AJAX/JSON)
  def msearch
    @search = params[:search].to_i
    respond_to do |format|
      if !@search.blank?
	@product = Product.where("gtin = ?", @search).first
	if !@product.blank? # and params[:callback]
	  #format.json { render action: 'search', status: :found, :callback => params[:callback] }
	  format.json { render :json => @product.to_json, :callback => params[:callback] }
	else
	  format.json { render :json => { :error => "No such product!"}, :callback => params[:callback] }
	  # status: 404, 
	end
      end
    end
  end
  
  # about
  def about
  end

  # index
  def index
  end

  # contact
  def contact
  end

  # sitemap
  def sitemap
  end
  
  # tos
  def tos
  end
  
  # pp
  def pp
  end
  
  private
    # permit something FIXME not in use?
    def p
      params.require(:product).permit(:gtin)
    end
end
