json.array!(@veganities) do |veganity|
  json.extract! veganity, :name, :description, :image, :color
  json.url veganity_url(veganity, format: :json)
end
