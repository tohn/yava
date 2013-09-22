json.array!(@packagematerials) do |packagematerial|
  json.extract! packagematerial, :name, :description, :http
  json.url packagematerial_url(packagematerial, format: :json)
end
