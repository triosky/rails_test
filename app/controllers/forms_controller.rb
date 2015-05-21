class Private::FormsController < Private::ModuleController

  # GET - company_forms_path
  #
  def index
    @forms = current_company.forms
  end

end