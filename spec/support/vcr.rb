require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
