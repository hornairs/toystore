module Toy
  module Extensions
    module Boolean
      Mapping = {
        true    => true,
        'true'  => true,
        'TRUE'  => true,
        'True'  => true,
        't'     => true,
        'T'     => true,
        '1'     => true,
        'on'    => true,
        'ON'    => true,
        1       => true,
        1.0     => true,
        false   => false,
        'false' => false,
        'FALSE' => false,
        'False' => false,
        'f'     => false,
        'F'     => false,
        '0'     => false,
        'off'   => false,
        'OFF'   => false,
        0       => false,
        0.0     => false,
        nil     => nil
      }

      def to_store(value, *)
        if value.is_a?(Boolean)
          value
        else
          Mapping[value]
        end
      end

      def from_store(value, *)
        to_store(value)
      end
    end
  end
end

class Boolean
  extend Toy::Extensions::Boolean
end