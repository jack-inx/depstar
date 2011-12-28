xml.instruct!
xml.response do
  xml.total @categories.count
  xml.returned @categories.count
  xml.categories do
    @categories.each do |category|
      unless category.usell_category_code.nil?
        xml.category do
          xml.id category.id
          xml.name case category.usell_category_code
                    when 1
                      'Cell Phones'
                    when 2
                      'Tablets'
                    when 3
                      'MP3 Players'
                    when 4
                      'Game Consoles'
                    when 5
                      'E-Readers'
                    when 6
                      'Digital Cameras'
                    else
                      ''
                    end
        end
      end
    end
  end
end