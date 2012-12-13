ActiveAdmin.register User do  
  menu :priority => 1,:label => "Affiliates"  
  
  index do                            
    column :username                     
    column :email
    column :crypted_password
    column :created_at     
    column :status
    # column "Orders" do |expert|
      # link_to "View", edit_admin_expert_path(expert)
    # end
      
    
    default_actions                  
  end                                 

  filter :username
  filter :email     
  filter :status                  

  csv :separator => ';' do
     column :username
     column :email
     column :created_at
  end                          
  
  form do |f| 
    f.inputs :username
    f.inputs :email
    f.inputs :crypted_password      
    f.inputs :status
    f.actions                         
  end 
  
  show do
    div :class => 'panel' do
      h3 'Affiliate'
      div :class => 'panel_contents' do
        div :class => 'attributes_table users' do
          table do
            tr do
              th { 'Username' }
              td { user.username }
            end
            tr do
              th { 'Email' }
              td { user.email }
            end
            tr do
              th { 'Password' }
              td { user.crypted_password }
            end
            tr do
              th { 'Login as' }
              td { link_to user.username, "/admin_as_affiliate/#{user.id}/affiliate" }
            end
      
            
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end #
  
end
