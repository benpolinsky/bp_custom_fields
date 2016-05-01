require 'test_helper'

module BpCustomFields
  class GroupsControllerTest < ActionController::TestCase
    setup do
      @group = bp_custom_fields_groups(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:groups)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create group" do
      assert_difference('Group.count') do
        post :create, group: { location: @group.location, name: @group.name, visible: @group.visible }
      end

      assert_redirected_to group_path(assigns(:group))
    end

    test "should show group" do
      get :show, id: @group
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @group
      assert_response :success
    end

    test "should update group" do
      patch :update, id: @group, group: { location: @group.location, name: @group.name, visible: @group.visible }
      assert_redirected_to group_path(assigns(:group))
    end

    test "should destroy group" do
      assert_difference('Group.count', -1) do
        delete :destroy, id: @group
      end

      assert_redirected_to groups_path
    end
  end
end
