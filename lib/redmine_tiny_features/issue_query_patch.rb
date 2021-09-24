require_dependency 'query'
require_dependency 'issue_query'

module RedmineTinyFeatures
  module IssueQueryPatch

    def initialize_available_filters
      super

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
    end
    
  end
end

IssueQuery.prepend RedmineTinyFeatures::IssueQueryPatch
