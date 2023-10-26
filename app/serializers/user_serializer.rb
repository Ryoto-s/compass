class UserSerializer
  # To use serialized data, just write like below
  # SINGLE RECORD
  # UserSerializer.new(resource).serializable_hash[:data][:attributes]
  #
  # MULTIPLE RECORDS
  # UserSerializer.new(resource).serializable_hash[:data].map{|data| data[:attributes]}
  #
  # or JUST extract specific values
  # UserSerializer.new(resource).serializable_hash[:data][:attributes][:id]
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :created_at
end
