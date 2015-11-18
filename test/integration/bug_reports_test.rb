require 'test_helper'
class BugReportsTest < ActionDispatch::IntegrationTest
  test "valid bug report" do
    assert_difference 'BugReport.count', 1 do
      post '/bug_reports', {bug_report: {title: "Test bug", content: "This is a bug"}}
    end
  end
  
  test "invalid bug report" do
   assert_no_difference 'BugReport.count' do
      post '/bug_reports', {bug_report: {title: "", content: "This is a bug"}}
    end
    assert_no_difference 'BugReport.count' do
      post '/bug_reports', {bug_report: {title: "Test bugs", content: ""}}
    end
  end
end