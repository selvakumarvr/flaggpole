class PromotionsController < ApplicationController
  layout "portal"

  # GET /promotions
  # GET /promotions.xml
  def index
    @promotions = Promotion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @promotions }
    end
  end

  # GET /promotions/1
  # GET /promotions/1.xml
  def show
    @promotion = Promotion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promotion }
    end
  end

  # GET /promotions/new
  # GET /promotions/new.xml
  def new
    @promotion = Promotion.new
    5.times { @promotion.promotion_zips.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @promotion }
    end
  end

  # GET /promotions/1/edit
  def edit
    @promotion = Promotion.find(params[:id])
  end

  # POST /promotions
  # POST /promotions.xml
  def create
    @promotion = Promotion.new(params[:promotion])

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to(root_url, :notice => 'Promotion was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /promotions/1
  # PUT /promotions/1.xml
  def update
    @promotion = Promotion.find(params[:id])

    respond_to do |format|
      if @promotion.update_attributes(params[:promotion])
        format.html { redirect_to(@promotion, :notice => 'Promotion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @promotion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /promotions/1
  # DELETE /promotions/1.xml
  def destroy
    @promotion = Promotion.find(params[:id])
    @promotion.destroy

    respond_to do |format|
      format.html { redirect_to(promotions_url) }
      format.xml  { head :ok }
    end
  end
end
