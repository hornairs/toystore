module Toy
  def self.identity_map
    Thread.current[:toystore_identity_map] ||= {}
  end

  module IdentityMap
    extend ActiveSupport::Concern

    included do
      identity_map_on
    end

    module ClassMethods
      def identity_map
        Toy.identity_map
      end

      def identity_map_on?
        @identity_map_on == true
      end

      def identity_map_off?
        !identity_map_on?
      end

      def identity_map_on
        @identity_map_on = true
      end

      def identity_map_off
        @identity_map_on = false
      end

      def without_identity_map(&block)
        begin
          original_identity_map_on = @identity_map_on
          identity_map_off
          yield
        ensure
          @identity_map_on = original_identity_map_on
        end
      end

      def get(id)
        get_from_identity_map(id) || super
      end

      def get_from_identity_map(id)
        return nil unless identity_map_on?
        identity_map[id]
      end

      def load(id, attrs)
        return nil if attrs.nil?

        if instance = identity_map[id]
          instance
        else
          super.tap { |doc| doc.add_to_identity_map }
        end
      end
    end

    def identity_map
      Toy.identity_map
    end

    def save(*)
      super.tap do |result|
        add_to_identity_map if result
      end
    end

    def delete(*)
      super.tap { remove_from_identity_map }
    end

    def add_to_identity_map
      return unless self.class.identity_map_on?
      identity_map[id] = self
    end

    def remove_from_identity_map
      return unless self.class.identity_map_on?
      identity_map.delete(id)
    end
  end
end