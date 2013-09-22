json.array!(@classnames) do |classname|
  json.extract! classname, :sg, :pl
  json.url classname_url(classname, format: :json)
end
