class UserSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name, :email, :username, :avatar
end