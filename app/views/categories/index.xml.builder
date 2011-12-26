xml.instruct!
xml.response do
  xml.total @categories.count
  xml.returned @categories.count
  xml.categories do
    @categories.each do |category|
      xml.category do
        xml.id category.id
        xml.name category.name
      end
    end
  end
end