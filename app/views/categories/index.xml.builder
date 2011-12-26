xml.instruct!
xml.categories do
  xml.total @categories.count
  xml.returned @categories.count
  @categories.each do |category|
    xml.category do
      xml.id category.id
      xml.name category.name
    end
  end
end