class SegmentsController < ApplicationController
  before_action :set_segment, only: %i[show edit update destroy export]



  def show
    render inertia: "Segments/Show", props: {
      segment: serialize_segment(@segment)
    }
  end

  def new
    @segment = current_user.segments.build
    render inertia: "Segments/Editor", props: {
      segment: { 
        title: "", content: "", 
        demo_link: "", repo_link: "", 
        is_unlisted: false, tags: [], 
        hours_logged: 0, point_multiplier: 1.0 
      },
      is_new: true
    }
  end

  def create
    @segment = current_user.segments.build(segment_params)
    if @segment.save
      GitHubService.publish_segment(@segment) if params[:publish] == "true"
      redirect_to project_path(@segment.project), notice: "Segment created."
    else
      redirect_back fallback_location: new_segment_path, inertia: { errors: @segment.errors.messages }
    end
  end

  def edit
    render inertia: "Segments/Editor", props: {
      segment: serialize_segment(@segment),
      is_new: false
    }
  end

  def update
    if @segment.update(segment_params)
      GitHubService.publish_segment(@segment) if params[:publish] == "true"
      redirect_to project_path(@segment.project), notice: "Segment updated."
    else
      redirect_back fallback_location: edit_segment_path(@segment), inertia: { errors: @segment.errors.messages }
    end
  end

  def destroy
    project = @segment.project
    @segment.destroy
    redirect_to project_path(project), notice: "Segment deleted."
  end

  def export
    format = params[:format]
    
    case format
    when "md"
      send_data @segment.content, filename: "#{@segment.title.parameterize}.md", type: "text/markdown"
    when "html"
      html_content = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(@segment.content)
      send_data html_content, filename: "#{@segment.title.parameterize}.html", type: "text/html"
    when "pdf"
      html_content = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(@segment.content)
      pdf = WickedPdf.new.pdf_from_string(html_content)
      send_data pdf, filename: "#{@segment.title.parameterize}.pdf", type: "application/pdf"
    when "docx"
      html_content = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(@segment.content)
      word = Htmltoword::Document.create(html_content)
      send_data word, filename: "#{@segment.title.parameterize}.docx", type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    else
      redirect_to @segment, alert: "Unsupported format"
    end
  end

  private

  def set_segment
    @segment = current_user.segments.find(params[:id])
  end

  def segment_params
    params.expect(segment: [ 
      :title, :content, 
      :demo_link, :repo_link, :is_unlisted, 
      :hours_logged, :point_multiplier, 
      :project_id,
      tags: [] 
    ])
  end

  def serialize_segment(segment)
    {
      id: segment.id,
      title: segment.title,
      content: segment.content,
      demo_link: segment.demo_link,
      repo_link: segment.repo_link,
      is_unlisted: segment.is_unlisted,
      tags: segment.tags,
      hours_logged: segment.hours_logged,
      point_multiplier: segment.point_multiplier.to_f,
      created_at: segment.created_at.strftime("%B %d, %Y")
    }
  end
end
