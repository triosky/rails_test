class Private::CompaniesController < Private::ModuleController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :list_locations_company, :list_teams_company, :list_users_company]

  respond_to :html

  def index
    @companies = Company.all
    respond_with(@companies)
  end

  def show
    respond_with(@company)
  end

  # def new
  #   @company = Company.new
  #   respond_with(@company)
  # end

  # def create
  #   @company = Company.new(company_params)
  #   @company.save
  #   respond_with(@company)
  # end

  def update
    @company.update(company_params)
    respond_with(@company)
  end

  # def destroy
  #   @company.destroy
  #   respond_with(@company)
  # end

  def calendar
    respond_with(@company)
  end

  def users
    respond_with(User.all)
  end

  def locations
    respond_with(Location.all)
  end

  def new_location
    new_location_params = {
      company_id: params[:id],
      name: params[:location_name]
    }

    location = Location.create(new_location_params)

    respond_to do |format|
      format.json {
        render json: { location_id: location.id }
      }
    end
  end

  def new_team
    new_team_params = {
      company_id: params[:id],
      name: params[:team_name]
    }

    team = Team.create(new_team_params)

    respond_to do |format|
      format.json {
        render json: { team_id: team.id }
      }
    end
  end

  def list_locations_company
    locations = @company.locations.order('locations.name').as_json(only: [:id, :name])

    respond_to do |format|
      format.json {
        render json: { locations: locations }
      }
    end
  end

  def list_teams_company
    teams = @company.teams.order('teams.name').as_json(only: [:id, :name])

    respond_to do |format|
      format.json {
        render json: { teams: teams }
      }
    end
  end

  def list_users_company
    users = @company.users.where.not(id: current_user.id).as_json(only: [:id, :email])

    respond_to do |format|
      format.json {
        render json: { users: users }
      }
    end
  end

  def custom_fields

  end

  def expense_settings

  end

  def billings

  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :description, :logo, :user_id, :plan_id, :address_id)
    end
end
