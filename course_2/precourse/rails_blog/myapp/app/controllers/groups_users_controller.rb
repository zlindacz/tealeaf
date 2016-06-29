class GroupsUsersController < ApplicationController
  before_action :set_groups_user, only: [:show, :edit, :update, :destroy]

  # GET /groups_users
  # GET /groups_users.json
  def index
    @groups_users = GroupsUser.all
  end

  # GET /groups_users/1
  # GET /groups_users/1.json
  def show
  end

  # GET /groups_users/new
  def new
    @groups_user = GroupsUser.new
  end

  # GET /groups_users/1/edit
  def edit
  end

  # POST /groups_users
  # POST /groups_users.json
  def create
    @groups_user = GroupsUser.new(groups_user_params)

    respond_to do |format|
      if @groups_user.save
        format.html { redirect_to @groups_user, notice: 'Groups user was successfully created.' }
        format.json { render :show, status: :created, location: @groups_user }
      else
        format.html { render :new }
        format.json { render json: @groups_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups_users/1
  # PATCH/PUT /groups_users/1.json
  def update
    respond_to do |format|
      if @groups_user.update(groups_user_params)
        format.html { redirect_to @groups_user, notice: 'Groups user was successfully updated.' }
        format.json { render :show, status: :ok, location: @groups_user }
      else
        format.html { render :edit }
        format.json { render json: @groups_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups_users/1
  # DELETE /groups_users/1.json
  def destroy
    @groups_user.destroy
    respond_to do |format|
      format.html { redirect_to groups_users_url, notice: 'Groups user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_groups_user
      @groups_user = GroupsUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def groups_user_params
      params[:groups_user]
    end
end
