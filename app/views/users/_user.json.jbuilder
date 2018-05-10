json.extract! user, :id, :instagram, :twitter, :facebook, :github, :created_at, :updated_at
json.url user_url(user, format: :json)
