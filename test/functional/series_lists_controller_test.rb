require 'test_helper'

class SeriesListsControllerTest < ActionController::TestCase
  setup do
    @series_list = series_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:series_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create series_list" do
    assert_difference('SeriesList.count') do
      post :create, series_list: {  }
    end

    assert_redirected_to series_list_path(assigns(:series_list))
  end

  test "should show series_list" do
    get :show, id: @series_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @series_list
    assert_response :success
  end

  test "should update series_list" do
    put :update, id: @series_list, series_list: {  }
    assert_redirected_to series_list_path(assigns(:series_list))
  end

  test "should destroy series_list" do
    assert_difference('SeriesList.count', -1) do
      delete :destroy, id: @series_list
    end

    assert_redirected_to series_lists_path
  end
end
