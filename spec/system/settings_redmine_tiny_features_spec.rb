require "spec_helper"

RSpec.describe "settings_redmine_tiny_features", type: :system do
  fixtures :users

  it "Should active the option paginate_issue_filters_values" do
    if Redmine::Plugin.installed?(:redmine_base_select2)
      log_user('admin', 'admin')
      visit 'settings/plugin/redmine_tiny_features'

      find("input[name='settings[use_select2]']").click
      find("input[name='settings[paginate_issue_filters_values]']").click
      find("input[name='commit']").click
      expect(Setting["plugin_redmine_tiny_features"]["use_select2"]).to eq '1'
      expect(Setting["plugin_redmine_tiny_features"]["paginate_issue_filters_values"]).to eq "1"
    end
  end

  it "Should active the option do_not_preload_issue_edit_form" do
    log_user('admin', 'admin')
    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues" => "1",
      "default_open_status" => "2",
      "default_project" => "1",        
    }
    visit 'settings/plugin/redmine_tiny_features'
    
    find("input[name='settings[do_not_preload_issue_edit_form]']").click
    find("input[name='commit']").click    
    
    expect(Setting["plugin_redmine_tiny_features"]["do_not_preload_issue_edit_form"]).to eq '1'
    Setting.send "plugin_redmine_tiny_features=", {
      "warning_message_on_closed_issues" => "1",
      "default_open_status" => "2",
      "default_project" => "1",
      "do_not_preload_issue_edit_form" => "0",
    }
  end
end
