json.array!(@nutvals) do |nutval|
  json.extract! nutval, :energy, :proteins, :carbohydrates, :sugar, :fat, :saturated, :monounsaturated, :polyunsaturated, :roughages, :natrium, :breadunits, :alcohol
  json.url nutval_url(nutval, format: :json)
end