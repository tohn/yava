json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :name, :description, :veganity_id
  json.url ingredient_url(ingredient, format: :json)
end