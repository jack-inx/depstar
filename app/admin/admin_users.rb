ActiveAdmin.register AdminUser do
  menu :priority => 1
  
  actions :edit, :update, :create, :show, :index, :new, :destroy
  filter :email     
   
  
 index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end
  
   show do
    div :class => 'panel' do
      h3 'AdminUsers'
      div :class => 'panel_contents' do
        div :class => 'attributes_table admin_users' do
          table do
            tr do
              th { 'Username' }
              td { admin_user.email }
            end        
      
            
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # 
end
