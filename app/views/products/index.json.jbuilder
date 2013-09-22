json.array!(@products) do |product|
  json.extract! product, :gtin, :image, :name, :description, :category_id, :nutval_id, :packagematerial_id, :packagesize, :country_id, :brand_id, :veganity_id, :source, :integrity, :user_id
  json.url product_url(product, format: :json)
end