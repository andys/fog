require 'fog/compute/models/server'

module Fog
  module Compute
    class Octopus

      class Server < Fog::Compute::Server

        identity :id
        attribute :name
        attribute :cores
        attribute :flavor
        attribute :gb_disk
        
        attribute :status
        attribute :internal_ip
        attribute :ip_addresses, :type => :array
        
        def ip_address
          ip_addresses.first
        end

        def available_actions
          connection.list("servers/#{id}/action")
        end
        
        def can?(action_name)
          available_actions.include?(action_name.to_s)
        end
        
        def action!(action_type, param=nil)
          param_hash = {:type => action_type}
          param_hash.merge!(Hash===param ? param : {:param => param})
          connection.create("servers/#{id}/action", param_hash)
        end
        
        def ready?
          status.to_s == 'Running'
        end
        
        def save_attributes
          Hash[*([:gb_disk, :name, :cores, :flavor].map {|f| [f.to_s, send(f)]}.flatten)]
        end
        
        def save
          if new_record?
            merge_attributes(
              connection.create('server', save_attributes)['server']
            )
          else
            connection.update('server', self.id, save_attributes)['server']
          end
        end
      end

    end
  end
end
