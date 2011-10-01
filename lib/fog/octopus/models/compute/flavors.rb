require 'fog/core/collection'
require 'fog/octopus/models/compute/flavor'

module Fog
  module Compute
    class Octopus

      class Flavors < Fog::Collection

        model Fog::Compute::Octopus::Flavor

        def all
          data = connection.list('flavor')
          load(data.values)
        end

        def get(flavor_id)
          data = connection.show('flavor', flavor_id)
          new(data)
        rescue Fog::Compute::Octopus::NotFound
          nil
        end

      end

    end
  end
end
