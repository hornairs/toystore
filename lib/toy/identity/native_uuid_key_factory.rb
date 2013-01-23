module Toy
  module Identity
    class NativeUUIDKeyFactory < AbstractKeyFactory
      def key_type
        SimpleUUID::UUID
      end

      def next_key(object)
        SimpleUUID::UUID.new
      end

      def to_key(object)
        [object.id.to_guid] if object.persisted?
      end
    end
  end
end
