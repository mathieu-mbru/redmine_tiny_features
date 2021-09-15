require_dependency 'queries_controller'

class QueriesController

  def author_values_pagination

    total_query = Query.new
    total = total_query.author_values_with_pagination(params['term'], 0, 0)

    # pass the maxPage for add user_anonymous in the last page
    maxPage =  (total.count.to_f / params['page_limit'].to_i).ceil

    issue_query = Query.new
    values = issue_query.author_values_with_pagination(params['term'], params['page_limit'], params['page'], maxPage)

    render :json => {
      :results => get_data_for_pagination(total, values, true, maxPage),
      :total =>  total.count,
    }

  end

  def assigned_to_values_pagination
    total_query = Query.new
    total = total_query.assigned_to_values_with_pagination(params['term'], 0, 0)

    issue_query = Query.new
    values = issue_query.assigned_to_values_with_pagination(params['term'], params['page_limit'], params['page'])

    render :json => {
      :results => get_data_for_pagination(total, values),
      :total =>  total.count,
    }
  end

  private

  def get_data_for_pagination(total, values, with_anonymous = false, maxPage = 1)
    # Calculating the number of active users in order to know the page number on which we will put the label locked
    total_active = 0
    total.each  do |val|
      total_active += 1  if val[2].present? && val[2] == l("status_active")
    end

    if total_active == 0
      page_locked = params['page'].to_i
    else
      page_locked = (total_active / params['page_limit'].to_i)
    end

    data = []

    h_me = []
    h_active = []
    h_diactive = []
    h_anonymous = []

    myValue = values.shift() if params['page'] == "0" && values.count > 0 && values[0][1] == "me"

    # show "me" in the begining of list
    h_me = {'id' => myValue[1], 'text' => myValue[0]} if myValue.present?

    values.each  do |val|
      h_active.push({'id' => val[1], 'text' => val[0]}) if val[2] == l("status_active")
      h_diactive.push({'id' => val[1], 'text' => val[0]}) if val[2] == l("status_locked")
    end

    if with_anonymous
      #show "anonymous" in the end of list
      anonymousValue = values.pop() if ( (params['page'].to_i == (maxPage - 1)) && (values.count > 0) && (values[values.count-1][0] == l(:label_user_anonymous)) )
      h_anonymous = { 'id' => anonymousValue[1], 'text' => anonymousValue[0] } if anonymousValue.present?
    end

    data.push(h_me) if h_me.count > 0

    data.push({
      id: 1,
      text: l("status_active"),
       children:[]
    }) if h_active.count > 0 && (params['page'] == "0")

    data.push({
      parent: 1,
      children:  h_active
    }) if h_active.count > 0

    data.push({
      id: 2,
      text: l("status_locked"),
      children:  []
    }) if h_diactive.count > 0  && (params['page'].to_i  ==  page_locked)

    data.push({
      parent: 2,
      children:  h_diactive
    }) if h_diactive.count > 0

    data.push(h_anonymous) if h_anonymous.count > 0
    data
  end
end