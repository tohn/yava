json.array!(@brands) do |brand|
  json.extract! brand, :name
  json.url brand_url(brand, format: :json)
end