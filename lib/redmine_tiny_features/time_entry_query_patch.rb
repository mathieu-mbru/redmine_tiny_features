require_dependency 'query'
require_dependency 'time_entry_query'

module RedmineTinyFeatures
  module TimeEntryQueryPatch

    def initialize_available_filters
      super

      add_available_filter(
        "user_id",
        :type => :list_optional, :values => lambda { author_values_with_pagination }
      )
      add_available_filter(
        "author_id",
        :type => :list_optional, :values => lambda { author_values_with_pagination }
      )
    end
    
  end
end

TimeEntryQuery.prepend RedmineTinyFeatures::TimeEntryQueryPatch
