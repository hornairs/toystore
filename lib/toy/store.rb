module Toy
  module Store
    extend ActiveSupport::Concern
    extend Plugins

    included do
      include Toy::Object
      include Persistence
      include MassAssignmentSecurity
      include DirtyStore
      include Querying
      include Reloadable

      include Callbacks
      include Validations
      include Timestamps

      include Lists
      include References
      include AssociationSerialization
      include Indices

      include IdentityMap
      include Caching
    end
  end
end
