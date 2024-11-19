class Homepage::ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :active
end
