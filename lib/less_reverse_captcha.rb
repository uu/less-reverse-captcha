module Less
  module ReverseCaptcha

    module Validations
      def self.append_features(base)
        super
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Validates whether the value of the specified attribute passes the captcha challenge
        #
        #   class User < ActiveRecord::Base
        #     validates_less_reverse_captcha        #   end
        #
        # Configuration options:
        # * <tt>message</tt> - A custom error message (default is: " can not create this because you are the sux.")
        # * <tt>on</tt> Specifies when this validation is active (default is :create, other options :save, :update)
        # * <tt>if</tt> - Specifies a method, proc or string to call to determine if the validation should
        #   occur (e.g. :if => :allow_validation, or :if => Proc.new { |user| user.signup_step > 2 }).  The
        #   method, proc or string should return or evaluate to a true or false value.
        def validates_less_reverse_captcha(options = {})
          attr_accessor :less_value_for_text_input

          configuration = { :message => ' can not create this because you are the sux.', :on => :create }

          configuration.merge(options)

          validates_each(:less_value_for_text_input, configuration) do |record, attr_name, value|
            record.errors.add('you', configuration[:message]) unless record.send(:less_value_for_text_input).blank?
          end
        end
      end
    end

    module Helper
      # Use this helper to create a captcha challenge question
      #
      #   <%= less_reverse_captcha_field :entry %>
      #
      # the following HTML will be generated. The hidden field contains an encrypted version of the answer
      #
      #   <input id="entry_less_value_for_text_input" name="entry[less_value_for_text_input]" size="30" type="text" />
      #   <script type="text/javascript">
      #     //<![CDATA[
      #       e = document.getElementById('entry_less_value_for_text_input'); e.parentNode.removeChild(e);
      #     //]]>
      #   </script>
      #
      # You can use the +options+ argument to pass additional options to the text-field tag.
      # pass :unobtrusive => true if you want to hide the field in an unobtrusive way. 
      def less_reverse_captcha_field(object, options={})
        html = ActionView::Helpers::InstanceTag.new(object, :less_value_for_text_input, self).to_input_field_tag("text")
        unobtrusive = options.delete :unobtrusive
        html += javascript_tag("e = document.getElementById('#{object}_less_value_for_text_input'); e.parentNode.removeChild(e);") unless unobtrusive
        html
      end
    end
  end
end