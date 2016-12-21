class StudentsController < ApplicationController
  include ErrorsHelper
  include PermissionsHelper

  before_action :set_student, only: [ :update, :destroy ]
  before_action :check_permissions, only: [ :update, :destroy ]

  def create
    @student = Student.create(student_params)

    @student.term.assignments.each do |assignment|
      job = @student.jobs.create(homework_id: assignment.id)

      assignment.problems.each do |problem|
        job.tasks.create(student_id: job.student.id, user_id: @student.user.id, problem_id: problem.id, problem_number: problem.number)
      end
    end

    redirect_to :back
  end

  def update
    @student.update(params.require(:student).permit(:approved))

    redirect_to @student.term.course
  end

  def destroy
    course = @student.term.course
    @student.destroy

    redirect_to course
  end

  private
    def student_params
      params.require(:student).permit(:term_id).merge(user_id: current_user.id)
    end

    def set_student
      @student = Student.find(params[:id])
    end

    def check_permissions
      Errors.forbidden(self) unless
          Permissions.has_edit_course_permissions?(current_user, @student.term.course)
    end
end
