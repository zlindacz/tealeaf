class UsersGroupsController < ApplicationController
  before_action :set_users_group, only: [:show, :edit, :update, :destroy]

  # GET /users_groups
  # GET /users_groups.json
  def index
    @users_groups = UsersGroup.all
  end

  # GET /users_groups/1
  # GET /users_groups/1.json
  def show
  end

  # GET /users_groups/new
  def new
    @users_group = UsersGroup.new
  end

  # GET /users_groups/1/edit
  def edit
  end

  # POST /users_groups
  # POST /users_groups.json
  def create
    @users_group = UsersGroup.new(users_group_params)

    respond_to do |format|
      if @users_group.save
        format.html { redirect_to @users_group, notice: 'Users group was successfully created.' }
        format.json { render :show, status: :created, location: @users_group }
      else
        format.html { render :new }
        format.json { render json: @users_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users_groups/1
  # PATCH/PUT /users_groups/1.json
  def update
    respond_to do |format|
      if @users_group.update(users_group_params)
        format.html { redirect_to @users_group, notice: 'Users group was successfully updated.' }
        format.json { render :show, status: :ok, location: @users_group }
      else
        format.html { render :edit }
        format.json { render json: @users_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users_groups/1
  # DELETE /users_groups/1.json
  def destroy
    @users_group.destroy
    respond_to do |format|
      format.html { redirect_to users_groups_url, notice: 'Users group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_group
      @users_group = UsersGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def users_group_params
      params[:users_group]
    end
end
