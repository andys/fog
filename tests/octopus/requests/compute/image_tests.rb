Shindo.tests('Fog::Compute[:octopus] | image requests', ['octopus']) do

  before do
    @compute = Fog::Compute.new(:provider => 'octopus', :octopus_username => 'test', :octopus_api_key => 'test')
  end

  tests('success') do
    tests('list(:image)').formats([String]) do
      pending if Fog.mocking?
      @compute.list(:image)
    end

  end

end
