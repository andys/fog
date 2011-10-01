module Fog
  module Compute
    class Octopus
      class Real

        def update(klass, id_field, attribs={})
          request("/#{klass}s/#{id_field}", {:attributes => attribs}, :method => 'PUT', :expects => [200, 201])
        end

      end
    end
  end
end
