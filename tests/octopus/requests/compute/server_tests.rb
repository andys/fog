Shindo.tests('Fog::Compute[:octopus] | server requests', ['octopus']) do

  before do
    @compute = Fog::Compute.new(
      :provider         => 'octopus',
      :octopus_username => 'test',
      :octopus_api_key  => 'test'
    )
    @server_name = "test#{Time.now.to_i}"
  end
  
  tests('success') do
    tests('server lifecycle') do
      pending if Fog.mocking?

      @server = nil
      test("#boostrap succeeds and returns a server ") do
        @server = @compute.servers.bootstrap(
          :name     => @server_name,
          :password => 'test123',
          :flavor   => 'Micro',
          :cores    => 1,
          :gb_disk  => 10,
          :image    => 'Ubuntu 10.04'
        )
        Fog::Compute::Octopus::Server === @server
      end

      @server_format = {:server => {:cores => Integer, :flavor => String, :gb_disk => Integer, :id => Integer, :name => String}}
      @action_format = {'action' => Hash}
      test('#servers list contains the new server') do
        @compute.servers.map(&:id).include? @server.id
      end
      
      test('#can?(:restart)') do
        @server.wait_for { can?('restart') } 
        @server.can?('restart')
      end

      tests('restart soft').formats(@action_format) do
        @server.action!(:restart, :soft)
      end
      
      test('#can?(:stop)') do
        @server.wait_for { can?('stop') } 
        @server.can?('stop')
      end

      tests('shutdown hard').formats(@action_format) do
        @server.action!(:stop, :hard)
      end

      tests('rename server') do
        tests('with a bad name').raises(Excon::Errors::UnprocessableEntity) do
          @server.reload
          @server.name += '!@#!%'
          @server.save
        end

        test('with a good name') do
          @server.reload
          old_name = @server.name
          @server.name += 'a'
          @server.save
          @server.reload
          @server.name == "#{old_name}a"
        end
      end

      test('reprovision server') do
        @server.reload
        @server.cores = 2
        @server.save
        @server.reload
        @server.cores == 2
      end


      test('#can?(:release)') do
        @server.wait_for { can?('release') } 
        @server.can?('release')
      end

      tests('release').formats(@action_format) do
        @server.action!(:release)
      end

      test('#can?(:delete)') do
        @server.wait_for { can?('delete') } 
        @server.can?('delete')
      end

      tests('delete').formats(@action_format) do
        @server.action!(:delete)
      end
      
    end
  end
  

  tests('failure') do
    tests('show server that doesnt exist').raises(Fog::Compute::Octopus::NotFound) do
      pending if Fog.mocking?
      @compute.show(:server, 0)
    end

    tests('create server with invalid name').raises(Excon::Errors::UnprocessableEntity) do
      pending if Fog.mocking?
      @compute.create(:server, :name=>'')
    end

  end

end
