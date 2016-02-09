json.array!(@results) do |result|
  json.extract! result, :id, :name, :likes
  json.url result_url(result, format: :json)
end
