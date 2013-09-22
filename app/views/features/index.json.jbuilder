json.array!(@features) do |feature|
  json.extract! feature, :name, :description
  json.url feature_url(feature, format: :json)
end