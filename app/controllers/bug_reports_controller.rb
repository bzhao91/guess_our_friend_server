class BugReportsController < ApplicationController
  def create
    bug_report = BugReport.new(bug_params)
    if bug_report.save
      render json: { message: "Thanks for reporting the bug"}
    else
      render json: { errors: "Unable to report the bug"}, :status => 900
    end
  end

  private
    def bug_params
      params.require(:bug_report).permit(:title, :content)
    end
end
