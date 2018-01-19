#module I18n
#  def self.localize(*args)
#    super.localize(*args) if args
#  end
#end

module ActionView
  module Helpers
    module TranslationHelper
      def localize(*args)
        I18n.localize(*args) if args
      end
    end
  end
end