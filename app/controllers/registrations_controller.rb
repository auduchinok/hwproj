class RegistrationsController < Devise::RegistrationsController
  # after_action :add_tasks, only: :create
  # after_action :send_notify, only: :create

  # def approve_student
  #   redirect_to :root if (not current_user.teacher?)

  #   @student = User.find(params[:id])
  #   redirect_to :back if @student.nil?

  #   @student.update(approved: true)
  #   redirect_to group_path(@student.group)
  # end

  # def destroy_student
  #   redirect_to :root if (not current_user.teacher?)

  #   @student = User.find(params[:id])
  #   @group = @student.group

  #   @student.destroy
  #   redirect_to @group
  # end

  protected

      def update_resource(resource, params)
        update_params = account_update_params
        if (update_params[:submission_form_type])
          resource.update_without_password(update_params)
        else
          resource.update_with_password(update_params)
        end
      end

      def after_update_path_for(resource)
        update_params = account_update_params
        if (update_params[:submission_form_type])
          return session[:task_url]
        else
          return "/"
        end
      end

  private

    # def add_tasks
    #   if @user.valid?

    #     @user.group.homeworks.each do |homework|
    #       job = @user.jobs.create(homework_id: homework.id)

    #       homework.problems.each do |problem|
    #         job.tasks.create(problem_id: problem.id, user_id: @user.id, homework_id: homework.id)
    #       end
    #     end
    #   end
    # end

    # def send_notify
    #   UserMailer.new_student_notify(@user).deliver
    # end

    def sign_up_params
      params.require(:user).permit(:name, :surname, :gender, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:name, :surname, :gender, :email, :password, :password_confirmation, :current_password, :submission_form_type)
    end
end
