require File.join(File.dirname(__FILE__), 'test_helper')
require 'test/unit'

class NoThing
  include Less::ReverseCaptcha::Validations
  validates_less_reverse_captcha
end

class LessCaptchaTest < Test::Unit::TestCase
  def setup 
    @thing = Thing.new(:name => 'thing') 
    @nothing = NoThing.new
  end

  def test_captcha_methods
    assert @thing.respond_to?('less_value_for_text_input')
  end
  
  def test_reverse_validation
    @thing.less_value_for_text_input = "blah"
    assert !@thing.valid?
    
    @thing.less_value_for_text_input = ""
    assert @thing.valid?
    
    @thing.less_value_for_text_input = nil
    assert @thing.valid?
  end
  
  def test_captcha_for_non_active_record_classes
    @nothing.less_value_for_text_input = "blah"
    assert !@nothing.validate_captcha
    
    @nothing.less_value_for_text_input = ""
    assert @nothing.validate_captcha
    
    @nothing.less_value_for_text_input = nil
    assert @nothing.validate_captcha
  end
end
