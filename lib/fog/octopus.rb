require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Octopus
    extend Fog::Provider
    service(:compute, 'octopus/compute')
  end
end
