class Query < ActiveRecord::Base
  def principals_with_pagination(term = '', limit = 0, page = 0)
   begin
      principals = []
      if project
        principals += Principal.member_of_with_pagination(project, term, limit, page).visible
        unless project.leaf?
          principals += Principal.member_of_with_pagination(project.descendants.visible, term, limit, page).visible
        end
      else
        principals += Principal.member_of_with_pagination(all_projects,term,limit,page).visible
      end

      principals.uniq!
      principals.sort!
      principals.reject! {|p| p.is_a?(GroupBuiltin)}
      principals
    end
  end

  def users_with_pagination(term = '', limit = 0, page = 0)
    principals_with_pagination(term, limit, page)
  end

  def author_values_with_pagination(term = '', limit = 0, page = 0, maxPage = 0)
    term ||= ''
    my_string = "me"
    anonymous_string = l(:label_user_anonymous)
    author_values = []
    author_values << ["<< #{l(:label_me)} >>", my_string] if User.current.logged? && page.to_i == 0 && l(:label_me).include?(term)
    author_values +=
      users_with_pagination(term, limit, page).sort_by(&:status).
        collect{|s| [s.name, s.id.to_s, l("status_#{User::LABEL_BY_STATUS[s.status]}")]}

    # limit = 0 ,for calculate the count of data total
    # anonymous_string.include?(term) for take into consideration the use anonymous
    with_user_anonymous = ((( maxPage.to_i == (page.to_i + 1)) && (anonymous_string.include?(term))) || ((limit == 0) && (anonymous_string.include?(term))))

    author_values << [anonymous_string, User.anonymous.id.to_s] if  with_user_anonymous
    author_values
  end

  def assigned_to_values_with_pagination(term = '', limit = 0, page = 0, maxPage = 0)
    term ||= ''
    my_string = "me"
    assigned_to_values = []
    assigned_to_values << ["<< #{l(:label_me)} >>", my_string] if User.current.logged? && page.to_i == 0 && l(:label_me).include?(term)
    assigned_to_values +=
      (Setting.issue_group_assignment? ? principals_with_pagination(term, limit, page) : users_with_pagination(term, limit, page)).sort_by(&:status).
        collect{|s| [s.name, s.id.to_s, l("status_#{User::LABEL_BY_STATUS[s.status]}")]}
    assigned_to_values
  end
end