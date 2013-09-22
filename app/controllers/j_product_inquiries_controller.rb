# JProductInquiriesController
class JProductInquiriesController < ApplicationController
  before_action :set_j_product_inquiry, only: [:show, :edit, :update, :destroy]

  # GET /j_product_inquiries
  # GET /j_product_inquiries.json
  def index
    @j_product_inquiries = JProductInquiry.paginate(:page => params[:page])
  end

  # GET /j_product_inquiries/1
  # GET /j_product_inquiries/1.json
  def show
  end

  # GET /j_product_inquiries/new
  def new
    @j_product_inquiry = JProductInquiry.new
  end

  # GET /j_product_inquiries/1/edit
  def edit
  end

  # POST /j_product_inquiries
  # POST /j_product_inquiries.json
  def create
    @j_product_inquiry = JProductInquiry.new(j_product_inquiry_params)

    respond_to do |format|
      if @j_product_inquiry.save
        format.html { redirect_to @j_product_inquiry, notice: 'J product inquiry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @j_product_inquiry }
      else
        format.html { render action: 'new' }
        format.json { render json: @j_product_inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /j_product_inquiries/1
  # PATCH/PUT /j_product_inquiries/1.json
  def update
    respond_to do |format|
      if @j_product_inquiry.update(j_product_inquiry_params)
        format.html { redirect_to @j_product_inquiry, notice: 'J product inquiry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @j_product_inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /j_product_inquiries/1
  # DELETE /j_product_inquiries/1.json
  def destroy
    @j_product_inquiry.destroy
    respond_to do |format|
      format.html { redirect_to j_product_inquiries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_j_product_inquiry
      @j_product_inquiry = JProductInquiry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def j_product_inquiry_params
      params.require(:j_product_inquiry).permit(:inquiry_id, :product_id)
    end
end
