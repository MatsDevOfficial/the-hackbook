# GitHub Integration Service (Mock)

module GitHubService
  def self.publish_project(project)
    user = project.user
    
    Rails.logger.info "GitHubService: Syncing project '#{project.name}' for user '#{user.display_name}'"
    
    # 1. Ensure Repo exists (Requires Administration: Read & Write)
    ensure_repo_exists(project)
    
    # 2. Update author.json (User metadata)
    update_file(project, "author.json", user_metadata(user))
    
    # 3. Update content.json (Project/Segments metadata)
    update_file(project, "content.json", project_metadata(project))
    
    # 4. Update segments.md (All segments concatenated)
    update_file(project, "segments.md", concatenated_segments(project))
    
    true
  end

  def self.publish_segment(segment)
    # Trigger full project sync when a segment is updated
    publish_project(segment.project)
  end

  private

  def self.ensure_repo_exists(project)
    return if project.github_repo_name.present?
    
    Rails.logger.info "GitHubService: Creating new repository '#{project.name.parameterize}' (Requires Administration RW)"
    # Mocking octokit.create_repository
    project.update!(
      github_repo_name: project.name.parameterize,
      github_repo_url: "https://github.com/#{project.user.display_name}/#{project.name.parameterize}"
    )
  end

  def self.update_file(project, path, content)
    Rails.logger.info "GitHubService: Updating file '#{path}' in repo '#{project.github_repo_name}'"
    # Mocking octokit.create_or_update_contents
  end

  def self.user_metadata(user)
    {
      name: user.display_name,
      slack_id: user.slack_id,
      hca_id: user.hca_id
    }.to_json
  end

  def self.project_metadata(project)
    {
      name: project.name,
      description: project.description,
      prizes: project.selected_prizes,
      segments: project.segments.order(:created_at).map { |s| { id: s.id, title: s.title } }
    }.to_json
  end

  def self.concatenated_segments(project)
    project.segments.order(:created_at).map do |s|
      "# #{s.title}\n\n#{s.content}"
    end.join("\n\n---\n\n")
  end
end

