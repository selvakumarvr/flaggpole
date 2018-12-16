class Admin::OrganizationsController < ApplicationController
  before_filter :require_admin

  # GET /admin/organizations
  # GET /admin/organizations.json
  def index
    @organizations = Organization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organizations }
    end
  end

  # GET /admin/organizations/1
  # GET /admin/organizations/1.json
  def show
    @organization = Organization.includes(:users, :organization_links).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /admin/organizations/new
  # GET /admin/organizations/new.json
  def new
    @organization = Organization.new
    10.times { @organization.organization_links.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /admin/organizations/1/edit
  def edit
    @organization = Organization.includes(:organization_links).find(params[:id])
    remaining_link_count = 10 - @organization.organization_links.length
    remaining_link_count.times { @organization.organization_links.build }
  end

  # POST /admin/organizations
  # POST /admin/organizations.json
  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to admin_organization_path(@organization), notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/organizations/1
  # PUT /admin/organizations/1.json
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to admin_organization_path(@organization), notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/organizations/1
  # DELETE /admin/organizations/1.json
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :no_content }
    end
  end
end
