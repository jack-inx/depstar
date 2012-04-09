require 'test_helper'
require 'authlogic/test_case'
require 'net/http'

class ShippingDetailsControllerTest < ActionController::TestCase  
   USER_NAME, PASSWORD = "depstar1", "wonderland"
   
  #before_filter :authenticate, :except => [ :index ]
  
  setup do
    activate_authlogic
    @shipping_detail = shipping_details(:one)
  end
  
  test "send test order" do
    
    @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('depstar1', 'wonderland')
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    attributes = {
          :subject => "10 ways to get traffic by writing blog posts about arcane Rails tips",
          :body => "Just kidding, it's totally impossible"
        }
    @request.env['RAW_POST_DATA'] = attributes.to_json
    post :submit_external_order
    assert_select 'status', /success/ 
    
    # url = URI.parse('http://127.0.0.1:3000/orders/submit.xml')
    # request = Net::HTTP::Post.new(url.path)
    # #request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('depstar1', 'wonderland')
    # request.body = "<?xml version='1.0' encoding='UTF-8'?><somedata><name>Test Name 1</name><description>Some data for Unit testing</description></somedata>"
    # response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
    # 
    # url = URI.parse('http://127.0.0.1:3000/orders/submit.xml')
    # response = Net::HTTP::Post.new(url.path)
    # 
    #puts request
    
    # puts response.body
    puts @response.body
    

    #Note this test PASSES!
    #assert_equal 'success', response.get_fields('status')
    #debugger
    
  end
  
private
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == USER_NAME && password == PASSWORD
    end
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
