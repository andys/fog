module Fog
  module Compute
    class Octopus
      class Real

        def list(klass)
          request("/#{klass}s", nil, :method => 'GET', :expects => [200])
        end

      end
    end
  end
end
