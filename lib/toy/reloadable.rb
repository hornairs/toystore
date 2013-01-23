module Toy
  module Reloadable
    extend ActiveSupport::Concern

    def reload
      if attrs = adapter.read(persisted_id)
        attrs['id'] = persisted_id
        instance_variables.each        { |ivar| instance_variable_set(ivar, nil) }
        initialize_attributes
        send(:attributes=, attrs, new_record?)
        self.class.lists.each_key      { |name| send(name).reset }
        self.class.references.each_key { |name| send("reset_#{name}") }
      else
        raise NotFound.new(persisted_id)
      end
      self
    end
  end
end
