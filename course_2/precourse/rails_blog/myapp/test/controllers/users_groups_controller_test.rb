require 'test_helper'

class UsersGroupsControllerTest < ActionController::TestCase
  setup do
    @users_group = users_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create users_group" do
    assert_difference('UsersGroup.count') do
      post :create, users_group: {  }
    end

    assert_redirected_to users_group_path(assigns(:users_group))
  end

  test "should show users_group" do
    get :show, id: @users_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @users_group
    assert_response :success
  end

  test "should update users_group" do
    patch :update, id: @users_group, users_group: {  }
    assert_redirected_to users_group_path(assigns(:users_group))
  end

  test "should destroy users_group" do
    assert_difference('UsersGroup.count', -1) do
      delete :destroy, id: @users_group
    end

    assert_redirected_to users_groups_path
  end
end
