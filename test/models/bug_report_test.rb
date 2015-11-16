require 'test_helper'

class BugReportTest < ActiveSupport::TestCase
  def setup
    @bug_report = BugReport.new(title: "This is a bug", content: "Bug appears in game creation")
  end
  
  test "should be valid" do
    assert @bug_report.valid?
  end
  
  test "title should be present" do
    @bug_report.title = " "
    assert_not @bug_report.valid?
  end
  
  test "content should be present" do
    @bug_report.content = "  "
    assert_not @bug_report.valid?
  end
end
