$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.reject! { |e| e.include? 'TextMate' }
ENV['RAILS_ENV'] = 'test' unless ENV['RAILS_ENV']

require 'rubygems'
gem 'test-spec', '>= 0.4.0'
gem 'mocha', '~> 0.9.0'
gem "relevance-log_buddy", "~> 0.2"

require 'mocha'
require 'test/spec'
require 'log_buddy'
require 'active_support'
require 'action_controller'
require 'action_controller/test_process'
require 'active_record'

LogBuddy.init
require File.dirname(__FILE__) + '/../init'

module SpecHelper
  LOG_FILE_NAME = File.expand_path(File.join(File.dirname(__FILE__), "tmp", "test.log"))
  DATABASE = File.expand_path(File.join(File.dirname(__FILE__), "tmp", "brain_buster.sqlite3"))
   
  def logger
    @logger ||= Logger.new(LOG_FILE_NAME)
  end
  
  Column = ActiveRecord::ConnectionAdapters::Column
  
  # allow getting a BrainBuster model without hitting the database
  def stub_brain_buster(attributes = {})
    BrainBuster.stubs(:columns).returns(
              [Column.new("question", nil, "string", false), 
               Column.new("answer", nil, "string", false)])
    @brain_buster_stub ||= BrainBuster.new(attributes)
  end
  
  def default_stub
    stub_brain_buster(:question => "What is 2 + 2 ?", :answer => "4")
  end
  
  def stub_default_brain_buster
    BrainBuster.stubs(:find_random_or_previous).returns(default_stub)
  end
  
  def setup_database
    gem 'sqlite3-ruby'

    ActiveRecord::Base.logger = Logger.new(LOG_FILE_NAME)
    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => DATABASE)
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do
      create_table :brain_busters, :force => true do |t|
        t.column :question, :string
        t.column :answer, :string
      end
    end
  end
  
  def teardown_database
    FileUtils.rm DATABASE
  end
  
end