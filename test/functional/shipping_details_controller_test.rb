require 'test_helper'
require 'authlogic/test_case'
require 'net/http'
require 'http_authentication'

class ShippingDetailsControllerTest < ActionController::TestCase
  http_basic_authenticate_with :name => "depstar", :password => "wonderland", :only => :submit_external_order
  
  setup do
    activate_authlogic
    @shipping_detail = shipping_details(:one)
  end
  
  test "send test order" do
    
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    get 'submit_external_order'
    
    #assert_select 'success', /status/  
    
    puts @response.body
    
    # url = URI.parse('http://127.0.0.1:3000/orders/submit.xml')
    #     request = Net::HTTP::Post.new(url.path)
    #     request.body = "<?xml version='1.0' encoding='UTF-8'?><somedata><name>Test Name 1</name><description>Some data for Unit testing</description></somedata>"
    #     response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
    #     
    # url = URI.parse('http://127.0.0.1:3000/orders/submit.xml')
    # response = Net::HTTP::Post.new(url.path)

    #Note this test PASSES!
    #assert_equal 'success', response.get_fields('status')
    #debugger
    
  end
  
=begin
  test "should get index" do
    UserSession.create(users(:one))
    
    get :index
    assert_response :success
    assert_not_nil assigns(:shipping_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shipping_detail" do
    assert_difference('ShippingDetail.count') do
      post :create, :shipping_detail => @shipping_detail.attributes
    end

    assert_redirected_to shipping_detail_path(assigns(:shipping_detail))
  end

  test "should show shipping_detail" do
    UserSession.create(users(:one))
    get :show, :id => @shipping_detail.to_param
    assert_response :success
  end

  test "should get edit" do
    UserSession.create(users(:one))
    get :edit, :id => @shipping_detail.to_param
    assert_response :success
  end

  test "should update shipping_detail" do
    UserSession.create(users(:one))
    put :update, :id => @shipping_detail.to_param, :shipping_detail => @shipping_detail.attributes
    assert_redirected_to shipping_detail_path(assigns(:shipping_detail))
  end

  test "should destroy shipping_detail" do
    UserSession.create(users(:one))
    assert_difference('ShippingDetail.count', -1) do
      delete :destroy, :id => @shipping_detail.to_param
    end

    assert_redirected_to shipping_details_path
  end
=end
  
end
