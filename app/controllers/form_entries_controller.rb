require 'csv'

class Private::FormEntriesController < Private::ModuleController
  include ExpensesImportable
  respond_to :html, :json

  def index
    @forms = current_company.forms
    @entries = current_company.form_entries.includes(:user, :approver, :form)
  end

  # GET - new_company_task_entry_path(form_id)
  #
  def new
    @entry = form.entries.new
  end


  # POST - company_task_entries_path(form_id)
  #
  def create
    @entry = form.entries.new(entry_attributes)
    @entry.user = current_user

    if @entry.save
      # TO DO
      redirect_to company_tasks_path
    else
      render action: 'new'
    end
  end


  # GET - edit_company_task_entry_path(form_id, entry_id)
  #
  def edit
    @form = entry.form
    respond_with(@entry)
  end


  # PUT - company_task_entry_path(form_id, entry_id)
  #
  def update
    if entry.update_attributes(entry_attributes)
      # TO DO
      redirect_to company_tasks_path
    else
      render action: 'new'
    end
  end

  def show
    respond_with(entry)
  end

  # PUT -
  #
  def change_status
    redirect_to company_tasks_path
    return unless entry.can_approve?(current_user)

    case params[:status]
    when 'cancel'
      entry.update_attribute :status, 'canceled'
    when 'approve'
      entry.update_attribute :status, 'approved'
    end
  end


  private

  def entry_attributes
    params.require(:form_entry).permit(:date, :answers).tap do |whitelisted|
      whitelisted[:answers] = params[:form_entry][:answers]
    end
  end

  def entry
    @entry ||= current_company.form_entries.includes(:form => {:fields => :field_options}).where(user_id: current_user.id).find(params[:id])
  end

  def form
    @form ||= current_company.forms.find(params[:form_id])
  end

end
