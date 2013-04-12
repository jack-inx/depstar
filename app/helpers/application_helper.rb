module ApplicationHelper
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)    
    p "=====name : #{name} : f #{f} :association #{association}"
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      p "=============#{association}  #{builder}"
      render(association.to_s.singularize + "_fields", :f => builder)
    end    
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")        
  end
  
  def get_iphone_id()
    category = Category.arel_table
    return Category.where(category[:name].matches("%iph%")).first.id
  end
  def get_user_affiliate(id)
    @user_check = User.find(id)
    return @user_check 
  end
  def get_user(id)
    @user = User.find(id)
    if @user.is_affiliate_admin == false and !@user.user_id.nil?
      @user_list = @user.user_id
      @user = User.find(@user_list)
    end     
    return @user 
  end
  
  def get_suggested_price(product_id, user_id)
    @suggestion = Suggestion.find_by_product_id_and_user_id(product_id, user_id) 
  end
  
  def get_order_price(product_id, order_id)
    @suggestion = OrderProductPriceType.find_by_product_id_and_order_id(product_id, order_id) 
  end
  # def link_to_add_fields(name, f, association)
    # new_object = f.object.class.reflect_on_association(association).klass.new
    # fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      # render(association.to_s.singularize + "_fields", :f => builder)
    # end
    # link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  # end
#   
end
