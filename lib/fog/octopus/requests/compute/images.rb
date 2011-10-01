module Fog
  module Compute
    class Octopus
      class Real

        def images
          request('/images')
        end

      end
    end
  end
end
