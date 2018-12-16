class OrganizationMessagesController < ApplicationController
  before_filter :authenticate_portal_user!

  # GET /organization_messages
  # GET /organization_messages.xml
  def index
    @messages = current_portal_user.messages

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /organization_messages/1
  # GET /organization_messages/1.xml
  def show
    @message = current_portal_user.messages.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /organization_messages/new
  # GET /organization_messages/new.xml
  def new
    @message = OrganizationMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /organization_messages/1/edit
  def edit
    @message = current_portal_user.messages.find(params[:id])
  end

  # POST /organization_messages
  # POST /organization_messages.xml
  def create
    @message = current_portal_user.messages.build(params[:organization_message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to(portal_messages_path, :notice => 'OrganizationMessage was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /organization_messages/1
  # PUT /organizations_messages/1.json
  def update
    @message = current_portal_user.messages.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:organization_message])
        format.html { redirect_to portal_messages_path, :notice => 'Message was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
