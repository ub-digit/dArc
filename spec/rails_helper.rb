# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.around_http_request do |request|
    VCR.use_cassette(get_cassette_path(request), &request)
    VCR.turn_off!(:ignore_cassettes => true)
  end
end

# Comment these two lines out to use VCR cassettes!
VCR.turn_off!(:ignore_cassettes => true)
WebMock.allow_net_connect!


def get_cassette_path(request)
  return request.uri.to_s
end

RSpec.configure do |config|
  
  # Include helper classes
  config.include TestHelper

  # Create map for storing test data ids
  config.add_setting :db_ids
  RSpec.configuration.db_ids = {}

  # Actions performed before test suite is run
  config.before(:suite){

    # Set appropriate test config values
    Rails.application.config.api_key = "test_key"
    Rails.application.config.ownercode = "SE-GUB-TEST"
    #Rails.application.config.fedora_connection = Rails.application.config.fedora_test_connection

    # Create a test Archive object
    @archive = Archive.create()
    @archive.from_json({"title" => "Test Archive", "unitid" => "1337", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive"})
    @archive.save
    RSpec.configuration.db_ids[:archive] = @archive.id

    @archive2 = Archive.create()
    @archive2.from_json({"title" => "Test Archive 2", "unitid" => "13372", "unitdate" => "1337 - 14082", "unittitle" => "A vewy vewy quiet archive2"})
    @archive2.save
    RSpec.configuration.db_ids[:archive2] = @archive2.id

    # Create a test Authority(Person) object
    @person = Person.create()
    @person.from_json({"title" => "Test Person","authorized_forename" => "Test", "authorized_surname" => "Testsson", "type" => "person", "startdate" => "1305", "enddate" => "1845"})
    @person.save
    RSpec.configuration.db_ids[:person] = @person.id
    RSpec.configuration.db_ids[:authority] = @person.id

    @person2 = Person.create()
    @person2.from_json({"title" => "Test Person2","authorized_forename" => "Test2", "authorized_surname" => "Testsson2", "type" => "person", "startdate" => "13052", "enddate" => "18452"})
    @person2.save
    RSpec.configuration.db_ids[:person2] = @person2.id
    RSpec.configuration.db_ids[:authority2] = @person2.id

    @disk = Disk.create()
    @disk.from_json({"title" => "Test Disk", "archives" => [@archive.id]})
    @disk.save
    RSpec.configuration.db_ids[:disk] = @disk.id

    @disk2 = Disk.create()
    @disk2.from_json({"title" => "Test Disk2", "archives" => [@archive.id]})
    @disk2.save
    RSpec.configuration.db_ids[:disk2] = @disk2.id

    @disk_image = DiskImage.create()
    @disk_image.from_json({"title" => "Test Disk-Image", "disks" => [@disk.id]})
    @disk_image.save
    RSpec.configuration.db_ids[:disk_image] = @disk_image.id

    # Sleep to allow for index to update
    puts "================================"
    puts "Sleeping for 10 seconds to let the index catch up with all of our awesome test data!"
    10.times do |x|
      print "#{10-x}"
      4.times do |y|
        sleep(0.2)
        print "."
      end
      sleep(0.2)
    end
    print "0"
    puts ""
    puts "Let's roll!"
    puts "================================"
  }

  # Actions performed after test suite has been run
  config.after(:suite) {
    # Delete the test archive objects
    DiskImage.purge(RSpec.configuration.db_ids[:disk_image])
    Disk.purge(RSpec.configuration.db_ids[:disk])
    Disk.purge(RSpec.configuration.db_ids[:disk2])
    Archive.purge(RSpec.configuration.db_ids[:archive])
    Archive.purge(RSpec.configuration.db_ids[:archive2])
    Person.purge(RSpec.configuration.db_ids[:person])
    Person.purge(RSpec.configuration.db_ids[:person2])
  }
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
