json.array!(@labels) do |label|
  json.extract! label, :name, :feature_id
  json.url label_url(label, format: :json)
end