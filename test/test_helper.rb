require 'rubygems'
require 'active_record'
require "#{File.join(File.dirname(__FILE__), "..", "lib", "less_reverse_captcha")}"
require 'test/unit'
require 'active_support'
require 'active_support/test_case'

ActiveRecord::Base.send(:include, Less::ReverseCaptcha::Validations)

ActiveRecord::Base.configurations = {'sqlite3' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')
 
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::DEBUG

ActiveRecord::Schema.define(:version => 0) do
  create_table :things do |t|
    t.string :name
  end
end

class Thing < ActiveRecord::Base
  validates_less_reverse_captcha
end
