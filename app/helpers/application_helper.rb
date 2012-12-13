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
  
  def get_user(id)
    @user = User.find(id)
    return @user
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
