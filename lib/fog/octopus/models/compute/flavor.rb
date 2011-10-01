require 'fog/core/model'

module Fog
  module Compute
    class Octopus

      class Flavor < Fog::Model

        identity :name
        attribute :mb_ram

      end

    end
  end
end
