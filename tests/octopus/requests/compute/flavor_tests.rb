Shindo.tests('Fog::Compute[:octopus] | flavor requests', ['octopus']) do

  before do
    @compute = Fog::Compute.new(:provider => 'octopus', :octopus_username => 'test', :octopus_api_key => 'test')
  end

  tests('success') do
    tests('list(:flavor)') do
      test('returns list of flavors') do
        pending if Fog.mocking?
        @compute.list(:flavor).values.all? {|v| v.is_a? Hash }
      end
    end

  end

end
