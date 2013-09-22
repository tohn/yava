# JProductCommentsController
class JProductCommentsController < ApplicationController
  before_action :set_j_product_comment, only: [:show, :edit, :update, :destroy]

  # GET /j_product_comments
  # GET /j_product_comments.json
  def index
    @j_product_comments = JProductComment.paginate(:page => params[:page])
  end

  # GET /j_product_comments/1
  # GET /j_product_comments/1.json
  def show
  end

  # GET /j_product_comments/new
  def new
    @j_product_comment = JProductComment.new
  end

  # GET /j_product_comments/1/edit
  def edit
  end

  # POST /j_product_comments
  # POST /j_product_comments.json
  def create
    @j_product_comment = JProductComment.new(j_product_comment_params)

    respond_to do |format|
      if @j_product_comment.save
        format.html { redirect_to @j_product_comment, notice: 'J product comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @j_product_comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @j_product_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /j_product_comments/1
  # PATCH/PUT /j_product_comments/1.json
  def update
    respond_to do |format|
      if @j_product_comment.update(j_product_comment_params)
        format.html { redirect_to @j_product_comment, notice: 'J product comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @j_product_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /j_product_comments/1
  # DELETE /j_product_comments/1.json
  def destroy
    @j_product_comment.destroy
    respond_to do |format|
      format.html { redirect_to j_product_comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_j_product_comment
      @j_product_comment = JProductComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def j_product_comment_params
      params.require(:j_product_comment).permit(:comment_id, :product_id)
    end
end
