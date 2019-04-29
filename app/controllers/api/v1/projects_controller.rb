class Api::V1::ProjectsController < Api::V1::BaseController
    before_action :authenticate_api_v1_user!
    before_action :set_project, only:[:show,:update,:link_participant,:update_participant]
    before_action :set_studant, only:[:link_participant]
    before_action :set_participant, only:[:update_participant]

    def index
        @projects = Project.all
    end

    def show
    end

    def create
        @project = Project.new params_project
        unless @project.save
            render json: {errors: @project.errors.full_messages}, status: :bad_request
        end
    end

    def update
        @project.update params_project
        unless @project.save
            render json: {errors: @project.errors.full_messages}, status: :bad_request
        end
    end

    def link_participant
        unless @project.studant_already_subscribed?(@studant)
            if @project.link_participant(params_link_participant)
                render json: {message: "O aluno foi adicionado com sucesso ao projeto."}, status: 201 #ok
            else
                render json: {error: "Erro ao adicionar aluno."}, status: :bad_request
            end
        else
            render json: {error: "Esse aluno já foi adicionado ao projeto."}, status: :bad_request
        end
    end

    def update_participant
        @participant.update(params_update_participant)
        unless @participant.save
            render json: {message: "Erro ao atualizar dados do aluno."}, status: :bad_request
        else
        end
    end

    private

    def params_project
        params.permit(:name,:abstract)
    end

    def set_project
        @project = Project.find(params[:id])
    end

    def set_participant
        @participant = ProjectParticipant.find(params[:participant_id])
    end

    def set_studant
        @studant = Studant.find(params[:studant_id])
    end

    def params_link_participant
        params.permit(:studant_id, :start_year, :end_year, :file_to_upload)
    end

    def params_update_participant
        params.permit(:start_year, :end_year, :file_to_upload)
    end

end
