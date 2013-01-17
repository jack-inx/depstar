xml.instruct!
xml.response do
  xml.total @usell_categories.count
  xml.returned @usell_categories.count
  xml.categories do
    @usell_categories.each do |category|
      unless category.usell_category_code.nil?
        xml.category do
          xml.id category.usell_category_code
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