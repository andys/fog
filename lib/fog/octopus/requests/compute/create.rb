module Fog
  module Compute
    class Octopus
      class Real

        def create(klass, attribs={})
          request("/#{klass}s", {:attributes => attribs}, :method => 'POST', :expects => [200, 201])
        end

      end
    end
  end
end
