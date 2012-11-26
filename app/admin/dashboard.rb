ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }
 
 #columns do
   #column do
    # panel "Recent Posts" do
     #  ul do
     #    Product.recent(5).map do |post|
     #      li link_to(post.name, admin_product_path(post))
     #    end
     #  end
    # end
  # end
#end

# column do
#    panel "Recent Product" do
#        Product.order("released_at desc").limit(5)
#    end
#  end
  content :title => proc{ I18n.t("active_admin.dashboard") } do
   # div :class => "blank_slate_container", :id => "dashboard_default_message" do
   #  span :class => "blank_slate" do
   #     span "Welcome to Active Admin. This is the default dashboard page."
   #     small "To add dashboard sections, checkout 'app/admin/dashboards.rb'"
   #   end
   # end
columns do
  column do
    panel "Recent Shopping Details" do
      ul do
        #Shipping_detail.order('created_at desc').limit(5)
      end
    end
  end
  column do
    panel "Total Orders" do
        para ""
    end
  end
end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
