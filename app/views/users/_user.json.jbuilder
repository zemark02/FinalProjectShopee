json.extract! user, :id, :username, :password_digest, :email, :name, :address, :phone, :gender, :birthdate, :created_at, :updated_at
json.url user_url(user, format: :json)
