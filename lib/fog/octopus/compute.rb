require File.expand_path(File.join(File.dirname(__FILE__), '..', 'octopus'))
require 'fog/compute'
require 'multi_json'

module Fog
  module Compute
    class Octopus < Fog::Service

      def self.octopus_api_url
        'https://octopus.com.au/api/'
      end
      requires :octopus_username, :octopus_api_key
      recognizes :api_url
      
      model_path 'fog/octopus/models/compute'
      model       :flavor
      collection  :flavors
      model       :server
      collection  :servers
      #model       :action
      #collection  :actions

      request_path 'fog/octopus/requests/compute'
      request :create
      request :update
      request :show
      request :list
      request :images


      class Mock
        def initialize(options={})
          require 'multi_json'

          @octopus_username = options[:octopus_username]
          @octopus_api_key = options[:octopus_api_key]
          @api_url = options[:api_url] || Fog::Compute::Octopus.octopus_api_url
        end
        
        def request(*opts)
          raise 'Not implemented'
        end
      end

      class Real
        def initialize(options={})
          require 'multi_json'

          @octopus_username = options[:octopus_username]
          @octopus_api_key = options[:octopus_api_key]
          @api_url = options[:api_url] || Fog::Compute::Octopus.octopus_api_url
          @connection = Fog::Connection.new(@api_url)
        end

        def reload
          @connection.reset
        end

        def request(path, data=nil, params={})
          params = {
            :expects  => 200,
            :method   => 'GET',
            :body     => data ? MultiJson.encode(data) : '',
          }.merge!(params)
          params[:headers] ||= {}
          params[:headers].merge!({
            'Authorization' => "Basic "+Base64.encode64("#{@octopus_username}:#{@octopus_api_key}").chomp,
            'Accept'        => 'application/json',
            "HTTP_ACCEPT"   => 'application/json',
            'Content-type'  => 'application/json'
          })
          begin
            params.merge!(:path => "/api#{path}.json")
            response = @connection.request(params)
          rescue Excon::Errors::NotFound => error
            raise Fog::Compute::Octopus::NotFound.slurp(error)
          end
          
          MultiJson.decode(response.body)
        end

      end
    end
  end
end
