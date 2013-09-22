json.array!(@manufacturers) do |manufacturer|
  json.extract! manufacturer, :name, :street, :city_id, :http, :email, :tel, :fax, :image
  json.url manufacturer_url(manufacturer, format: :json)
end
