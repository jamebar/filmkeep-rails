class CommentSerializer < ActiveModel::Serializer
  self.root = false
  belongs_to :films
end