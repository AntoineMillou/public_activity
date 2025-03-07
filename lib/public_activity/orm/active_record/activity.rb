# frozen_string_literal: true

module PublicActivity
  unless defined? ::PG::ConnectionBad
    module ::PG
      class ConnectionBad < Exception; end
    end
  end
  unless defined? Mysql2::Error::ConnectionError
    module Mysql2
      module Error
        class ConnectionError < Exception; end
      end
    end
  end

  module ORM
    module ActiveRecord
      # The ActiveRecord model containing
      # details about recorded activity.
      class Activity < ::ActiveRecord::Base
        include Renderable
        self.table_name = PublicActivity.config.table_name
        self.abstract_class = true

        # Define polymorphic association to the parent
        belongs_to :trackable, polymorphic: true

        before_create :set_uuid

        case ::ActiveRecord::VERSION::MAJOR
        when 6..7
          with_options(optional: true) do
            # Define ownership to a resource responsible for this activity
            belongs_to :owner, polymorphic: true
            # Define ownership to a resource targeted by this activity
            belongs_to :recipient, polymorphic: true
          end
        end



        if ::ActiveRecord::VERSION::MAJOR < 4 || defined?(ProtectedAttributes)
          attr_accessible :key, :owner, :parameters, :recipient, :trackable
        end

        def set_uuid
          return unless self.has_attribute?(:uuid)
          self.uuid = SecureRandom.uuid unless self.uuid.present?
        end
      end
    end
  end
end
