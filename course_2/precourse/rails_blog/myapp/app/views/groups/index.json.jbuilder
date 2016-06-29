json.array!(@groups) do |group|
  json.extract! group, :id, :group_name, :user_name, :color
  json.url group_url(group, format: :json)
end
