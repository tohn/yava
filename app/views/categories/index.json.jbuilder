json.array!(@categories) do |category|
  json.extract! category, :name, :category_id
  json.url category_url(category, format: :json)
end
