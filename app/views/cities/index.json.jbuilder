json.array!(@cities) do |city|
  json.extract! city, :postcode, :name, :country_id
  json.url city_url(city, format: :json)
end