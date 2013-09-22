# JProductLabelsController
class JProductLabelsController < ApplicationController
  before_action :set_j_product_label, only: [:show, :edit, :update, :destroy]

  # GET /j_product_labels
  # GET /j_product_labels.json
  def index
    @j_product_labels = JProductLabel.paginate(:page => params[:page])
  end

  # GET /j_product_labels/1
  # GET /j_product_labels/1.json
  def show
  end

  # GET /j_product_labels/new
  def new
    @j_product_label = JProductLabel.new
  end

  # GET /j_product_labels/1/edit
  def edit
  end

  # POST /j_product_labels
  # POST /j_product_labels.json
  def create
    @j_product_label = JProductLabel.new(j_product_label_params)
    @j_product_label.user_id = current_user.id

    respond_to do |format|
      if @j_product_label.save
        format.html { redirect_to @j_product_label, notice: t("controller.created", model: t("activerecord.models.j_product_label")) }
	format.js   {}
        format.json { render action: 'show', status: :created, location: @j_product_label }
      else
        format.html { render action: 'new' }
	format.js   {}
        format.json { render json: @j_product_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /j_product_labels/1
  # PATCH/PUT /j_product_labels/1.json
  def update
    respond_to do |format|
      if @j_product_label.update(j_product_label_params)
        format.html { redirect_to @j_product_label, notice: t("controller.updated", model: t("activerecord.models.j_product_label")) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @j_product_label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /j_product_labels/1
  # DELETE /j_product_labels/1.json
  def destroy
    @j_product_label.destroy
    respond_to do |format|
      format.html { redirect_to j_product_labels_url }
      format.js   {}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_j_product_label
      @j_product_label = JProductLabel.find_by_id(params[:id].to_i)
      if @j_product_label.blank?
	redirect_to j_product_labels_path, alert: t("controller.notfound", model: t("activerecord.models.j_product_label"))
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def j_product_label_params
      params.require(:j_product_label).permit(:product_id, :label_id, :user_id)
    end
end
