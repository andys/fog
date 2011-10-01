require 'fog/core/collection'
require 'fog/octopus/models/compute/server'

module Fog
  module Compute
    class Octopus

      class Servers < Fog::Collection

        model Fog::Compute::Octopus::Server

        def all
          data = connection.list('server')
          load(data.map(&:values).map(&:first))
        end

        def get(server_id)
          data = connection.show('server', server_id)
          new(data['server'])
        rescue Fog::Compute::Octopus::NotFound
          nil
        end
        
        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          
          #puts "Cloning..."
          server.wait_for { can?(:clone) }
          server.action!(:clone, :image => new_attributes[:image])
          
          #puts "Provisioning..."
          server.wait_for { can?(:provision) }
          server.action!(:provision)
          
          #puts "Starting..."
          server.wait_for { can?(:start) }
          server.action!(:start)
          
          #puts "Setting password..."
          server.wait_for { can?(:setpass) }
          server.action!(:setpass, new_attributes[:password])
          server.reload
        end

      end

    end
  end
end
