

class ShoesController < ApplicationController

  before_action :set_shoe, only: %i[ show edit update destroy transfer ]

  # GET /shoes or /shoes.json
  def index
 
    @shoes = Shoe.all
  end

   # GET /shoes or /shoes.json
  def inventory
 
    @high_shoe =  Shoe.where("inventory > 100").order("inventory").reverse_order
    @low_shoe =  Shoe.where("inventory < 100").order("inventory")
  end

  # GET /shoes/1 or /shoes/1.json
  def show
  end

  # GET /shoes/new
  def new
    @shoe = Shoe.new
  end

  # GET /shoes/1/edit
  def edit
  end

  # POST /shoes or /shoes.json
  def create
    @shoe = Shoe.new(shoe_params)

    respond_to do |format|
      if @shoe.save
       
        format.html { redirect_to shoe_url(@shoe), notice: "Shoe was successfully created." }
        format.json { render :show, status: :created, location: @shoe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shoe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shoes/1 or /shoes/1.json
  def update
    respond_to do |format|
      if @shoe.update(shoe_params)
        format.html { redirect_to shoe_url(@shoe), notice: "Shoe was successfully updated." }
        format.json { render :show, status: :ok, location: @shoe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shoe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shoes/1 or /shoes/1.json
  def destroy
    @shoe.destroy

    respond_to do |format|
      format.html { redirect_to shoes_url, notice: "Shoe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Shoe.destroy_all

    respond_to do |format|
      format.html { redirect_to shoes_url, notice: "Shoe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PATCH/ PUT transfering inventroy to another store
  def transfer
    current_lowest = Shoe.where('inventory < 75').order('inventory').first
    transfer_amount = @shoe.inventory * 0.3
    if current_lowest
      respond_to do |format|

        if current_lowest.update(inventory: transfer_amount + current_lowest.inventory) and @shoe.update(inventory: @shoe.inventory - current_lowest.inventory)
          format.html { redirect_to shoe_url(@shoe), notice: "Shoe was successfully Transfered." }
          format.json { render :show, status: :ok, location: @shoe }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @shoe.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shoe
      @shoe = Shoe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shoe_params
      params.require(:shoe).permit( :name, :inventory, :store_id)
    end
end
