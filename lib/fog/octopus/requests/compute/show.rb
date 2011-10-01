module Fog
  module Compute
    class Octopus
      class Real

        def show(klass, id_param)
          request("/#{klass}s/#{id_param}")
        end

      end
    end
  end
end
