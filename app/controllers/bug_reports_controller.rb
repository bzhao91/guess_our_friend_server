class BugReportsController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  def create
    bug_report = BugReport.new(bug_params)
    if bug_report.save
      render json: { message: "Thanks for reporting the bug"}
    else
      render json: { errors: bug_report.errors}, :status => 900
    end
  end

  private
    def bug_params
      params.require(:bug_report).permit(:title, :content)
    end
end
