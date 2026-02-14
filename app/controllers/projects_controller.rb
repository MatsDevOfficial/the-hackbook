class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    scope = policy_scope(Project).includes(:user, :ships)
    scope = scope.search(params[:query]) if params[:query].present?
    @pagy, @projects = pagy(scope.order(created_at: :desc))

    render inertia: "Projects/Index", props: {
      projects: @projects.map { |p| serialize_project_card(p) },
      pagy: pagy_props(@pagy),
      query: params[:query].to_s
    }
  end

  def show
    authorize @project

    render inertia: "Projects/Show", props: {
      project: serialize_project_detail(@project),
      can: {
        update: policy(@project).update?,
        destroy: policy(@project).destroy?
      }
    }
  end

  def new
    @project = current_user.projects.build
    authorize @project

    render inertia: "Projects/Form", props: {
      project: { name: "", description: "", demo_link: "", repo_link: "", is_unlisted: false, tags: [], hours_logged: 0, point_multiplier: 1.0 },
      title: "New Project",
      submit_url: projects_path,
      method: "post"
    }
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project

    if @project.save
      # Automatically create a membership for the creator as leader
      @project.project_memberships.create!(user: current_user, role: :leader)
      
      redirect_to @project, notice: "Project created."
    else
      redirect_back fallback_location: new_project_path, inertia: { errors: @project.errors.messages }
    end
  end

  def invite
    @project = Project.find(params[:id])
    authorize @project, :update?
    
    invitation = @project.project_invitations.build(
      email: params[:email],
      role: params[:role] || :member,
      invited_by: current_user
    )

    if invitation.save
      ProjectInvitationMailer.with(invitation: invitation).invite.deliver_later
      redirect_back fallback_location: project_path(@project), notice: "Invitation sent to #{invitation.email}."
    else
      redirect_back fallback_location: project_path(@project), alert: invitation.errors.full_messages.to_sentence
    end
  end

  def join
    invitation = ProjectInvitation.find_by!(token: params[:token])
    
    membership = ProjectMembership.new(
      user: current_user,
      project: invitation.project,
      role: invitation.role
    )

    if membership.save
      invitation.destroy
      redirect_to membership.project, notice: "You've successfully joined the project!"
    else
      redirect_to home_path, alert: membership.errors.full_messages.to_sentence
    end
  end

  def edit
    authorize @project

    render inertia: "Projects/Form", props: {
      project: {
        id: @project.id,
        name: @project.name,
        description: @project.description.to_s,
        demo_link: @project.demo_link.to_s,
        repo_link: @project.repo_link.to_s,
        is_unlisted: @project.is_unlisted,
        tags: @project.tags,
        hours_logged: @project.hours_logged,
        point_multiplier: @project.point_multiplier.to_f
      },
      title: "Edit Project",
      submit_url: project_path(@project),
      method: "patch"
    }
  end

  def update
    authorize @project

    if @project.update(project_params)
      redirect_to @project, notice: "Project updated."
    else
      redirect_back fallback_location: edit_project_path(@project), inertia: { errors: @project.errors.messages }
    end
  end

  def destroy
    authorize @project
    @project.discard
    redirect_to projects_path, notice: "Project deleted."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.expect(project: [ :name, :description, :demo_link, :repo_link, :is_unlisted, :hours_logged, :point_multiplier, :project_type, :club_prizes, :github_repo, tags: [] ])
  end

  def serialize_project_card(project)
    {
      id: project.id,
      name: project.name,
      description: project.description&.truncate(200),
      is_unlisted: project.is_unlisted,
      tags: project.tags,
      user_display_name: project.user.display_name,
      ships_count: project.ships.size
    }
  end

  def serialize_project_detail(project)
    {
      id: project.id,
      name: project.name,
      description: project.description,
      demo_link: project.demo_link,
      repo_link: project.repo_link,
      is_unlisted: project.is_unlisted,
      tags: project.tags,
      hours_logged: project.hours_logged,
      point_multiplier: project.point_multiplier.to_f,
      project_type: project.project_type,
      club_prizes: project.club_prizes,
      github_repo: project.github_repo,
      user_display_name: project.user.display_name,
      created_at: project.created_at.strftime("%B %d, %Y"),
      segments: project.segments.order(created_at: :desc).map { |s| { id: s.id, title: s.title, created_at: s.created_at.strftime("%B %d, %Y") } },
      members: project.members.map { |m| { id: m.id, display_name: m.display_name, avatar: m.avatar } }
    }
  end
end
