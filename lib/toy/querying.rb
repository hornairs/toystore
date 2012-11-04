module Toy
  module Querying
    extend ActiveSupport::Concern

    module ClassMethods
      def get(id)
        Toy.logger.info "[ToyStore] #{self.name} GET #{id}"
        if (attrs = adapter.read(id))
          load(id, attrs)
        end
      end

      def get!(id)
        get(id) || raise(Toy::NotFound.new(id))
      end

      def get_multi(*ids)
        Toy.logger.info "[ToyStore] #{self.name} GET MULTI #{ids.join(' ')}"
        ids.flatten.map { |id| get(id) }
      end

      def get_or_new(id)
        get(id) || new(:id => id)
      end

      def get_or_create(id)
        get(id) || create(:id => id)
      end

      def key?(id)
        adapter.key?(id)
      end
      alias :has_key? :key?

      def load(id, attrs)
        attrs ||= {}
        instance = constant_from_attrs(attrs).allocate
        instance.initialize_from_database(attrs.update('id' => id))
      end

      def constant_from_attrs(attrs)
        return self if attrs.nil?

        type = attrs[:type] || attrs['type']

        return self if type.nil?

        type.constantize
      rescue NameError
        self
      end
      private :constant_from_attrs
    end
  end
end
