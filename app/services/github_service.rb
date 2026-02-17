# GitHub Integration Service (Mock)

module GitHubService
  def self.authorize_url(state)
    client_id = ENV.fetch("GITHUB_CLIENT_ID", nil)
    "https://github.com/login/oauth/authorize?client_id=#{client_id}&state=#{state}&scope=repo,user"
  end

  def self.exchange_code_for_token(code)
    response = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      req.headers["Accept"] = "application/json"
      req.body = {
        client_id: ENV.fetch("GITHUB_CLIENT_ID", nil),
        client_secret: ENV.fetch("GITHUB_CLIENT_SECRET", nil),
        code: code
      }
    end

    return nil unless response.success?
    JSON.parse(response.body)["access_token"]
  end

  def self.publish_project(project)
    user = project.user
    token = user.github_token
    
    unless token
      Rails.logger.warn "GitHubService: No GitHub token for user '#{user.email}'"
      return false
    end

    Rails.logger.info "GitHubService: Syncing project '#{project.name}' for user '#{user.display_name}'"
    
    # 1. Ensure Repo exists
    repo_name = ensure_repo_exists(project, token)
    return false unless repo_name
    
    # 2. Update files
    update_file(token, repo_name, "author.json", user_metadata(user))
    update_file(token, repo_name, "content.json", project_metadata(project))
    update_file(token, repo_name, "segments.md", concatenated_segments(project))
    
    true
  end

  def self.publish_segment(segment)
    publish_project(segment.project)
  end

  private

  def self.ensure_repo_exists(project, token)
    return project.github_repo_name if project.github_repo_name.present?
    
    name = project.name.parameterize
    Rails.logger.info "GitHubService: Creating new repository '#{name}'"
    
    response = github_client(token).post("/user/repos") do |req|
      req.body = { name: name, description: "Hack Club Hackbook Project: #{project.name}", private: false }.to_json
    end

    if response.success? || response.status == 422 # 422 if already exists but not in DB
      repo_data = JSON.parse(response.body)
      full_name = repo_data["full_name"] || "#{project.user.display_name}/#{name}" # Handle 422 fallback
      
      project.update!(
        github_repo_name: full_name,
        github_repo_url: "https://github.com/#{full_name}"
      )
      full_name
    else
      Rails.logger.error "GitHubService: Failed to create repo: #{response.status} - #{response.body}"
      nil
    end
  end

  def self.update_file(token, repo_full_name, path, content)
    Rails.logger.info "GitHubService: Updating file '#{path}' in repo '#{repo_full_name}'"
    
    # Get current file SHA if exists to update
    sha = nil
    get_res = github_client(token).get("/repos/#{repo_full_name}/contents/#{path}")
    sha = JSON.parse(get_res.body)["sha"] if get_res.success?

    github_client(token).put("/repos/#{repo_full_name}/contents/#{path}") do |req|
      req.body = {
        message: "Sync #{path} from Hackbook",
        content: Base64.strict_encode64(content),
        sha: sha
      }.compact.to_json
    end
  end

  def self.github_client(token)
    Faraday.new(url: "https://api.github.com") do |f|
      f.headers["Authorization"] = "Bearer #{token}"
      f.headers["Accept"] = "application/vnd.github.v3+json"
      f.headers["User-Agent"] = "HackClub-Hackbook"
    end
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

