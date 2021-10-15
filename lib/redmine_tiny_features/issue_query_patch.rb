require_dependency 'query'
require_dependency 'issue_query'

class IssueQuery < Query

  alias :find_updated_by_filter_values :find_assigned_to_id_filter_values
  alias :find_last_updated_by_filter_values :find_assigned_to_id_filter_values

end

module RedmineTinyFeatures
  module IssueQueryPatch

      def initialize_available_filters
        super
        # Add this condition,because of there are tests for available_filters in redmine core
        if  Setting["plugin_redmine_tiny_features"]["empty_available_filters"].present?
          add_available_filter(
            "author_id",
            :type => :list, :values => lambda { [] }
          )
          add_available_filter(
            "assigned_to_id",
            :type => :list_optional, :values => lambda { [] }
          )
          add_available_filter(
            "updated_by",
            :type => :list, :values => lambda { [] }
          )
          add_available_filter(
            "last_updated_by",
            :type => :list, :values => lambda { [] }
          )
        else
          add_available_filter(
            "author_id",
            :type => :list, :values => lambda { author_values }
          )
          add_available_filter(
            "assigned_to_id",
            :type => :list_optional, :values => lambda { assigned_to_values }
          )
          add_available_filter(
            "updated_by",
            :type => :list, :values => lambda { author_values }
          )
          add_available_filter(
            "last_updated_by",
            :type => :list, :values => lambda { author_values }
          )
        end
    end

  end

end

IssueQuery.prepend RedmineTinyFeatures::IssueQueryPatch
