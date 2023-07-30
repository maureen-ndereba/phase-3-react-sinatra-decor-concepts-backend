require 'sinatra'
require 'active_record'
require 'bcrypt'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require_relative '../../uploaders/avatar_uploader'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Load models
  require_relative '../models/designer'
  require_relative '../models/project-proposal'
  require_relative '../models/note'

  # Configure the database connection
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db/development.sqlite3' 
  )

  # Configure sessions for user authentication
  enable :sessions
  set :session_secret, 'luna_secret_key' 


  # Helper method to check if a designer is logged in
  def logged_in?
    !!session[:designer_id]
  end

  # Helper method to get the current logged-in designer
  def current_designer
    Designer.find_by(id: session[:designer_id]) if logged_in?
  end


  #Designer Routes 
  # Route to handle designer sign up (create a designer account)
  post '/designers' do
    # Get registration data from the request body
  registration_data = JSON.parse(request.body.read)
    # Create a new Designer record in the database
    designer = Designer.new(name: params[:name], email: params[:email], password: params[:password], status: 'active')
    # Save the designer to the database
    if designer.save
      # Success response: Redirect to a success page 
      { message: 'Designer account created successfully.', designer_id: designer.id, designer_name: designer.name }.to_json
    else
      # Error response: 
      { 
        error: true,
        message: 'Failed to create designer account.',
        errors: designer.errors.full_messages 
      }.to_json
    end
  end


  # Route to handle designer login
  post '/login' do
    designer = Designer.find_by(email: params[:email])
    if designer && designer.authenticate(params[:password])
      # Set up a session to maintain user login state
      session[:designer_id] = designer.id 
      # Successful login response: Redirect to a dashboard page or perform other actions
      { message: 'Login successful.', designer_id: designer.id, designer_name: designer.email }.to_json
    else
      # Error response: Render the error message as JSON
      { error: 'Invalid email or password.' }.to_json
    end
  end


  # Route to handle designer logout
  get '/logout' do
    if logged_in?
      session.clear # Clear the session to log out the designer
      { message: 'Logout successful.' }.to_json
    else
      { message: 'You are not logged in.' }.to_json
    end
  end
  
  # Route to view all designer's profiles
get '/designers' do
  designer_count = Designer.count
    { total_designers: designer_count }.to_json
end

# Route to view a specific designer's profile
get '/designers/:id' do
  begin
    designer = Designer.find(params[:id])
    designer.to_json
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: 'Designer not found.' }.to_json
  end
end

# Method to count designers created through seed data (identified by 'active' status)
def seed_designer_count
  Designer.where(status: 'active').count
end

# Route to get the total number of designers that are active
get '/active_designer_count' do
  designer_count = seed_designer_count()
  { total_active_designers: designer_count }.to_json
end

# Route to edit the current designer's profile
patch '/designers/:id' do
  designer = Designer.find(params[:id])
  if designer.update(name: params[:name], email: params[:email])
    # Success response: Render the updated profile as JSON
    designer.to_json
  else
    # Error response: Render the error message as JSON
    { error: designer.errors.full_messages }.to_json
  end
end

# Route to delete the current designer's account
delete '/designers/:id' do
  designer = Designer.find(params[:id])
  designer.destroy
  session.clear # Clear the session to log out the designer after account deletion
  # Success response: Render a confirmation message as JSON
  { message: 'Designer account deleted successfully.' }.to_json
end


#Project Proposal Routes 
# Route to create a project proposal for the current designer
post '/designers/:id/project_proposals' do
  designer = Designer.find(params[:id])
  project_proposal = designer.project_proposals.build(title: params[:title], description: params[:description])
  if project_proposal.save
    # Success response: Render the created project proposal as JSON
    project_proposal.to_json
  else
    # Error response: Render the error message as JSON
    { error: project_proposal.errors.full_messages }.to_json
  end
end

# Route to view a specific project proposal
get '/project_proposals/:id' do
  project_proposal = ProjectProposal.find(params[:id])
  # Success response: Render the project proposal details as JSON
  project_proposal.to_json
end

# Route to edit a specific project proposal
patch '/project_proposals/:id' do
  project_proposal = ProjectProposal.find(params[:id])
  if project_proposal.update(title: params[:title], description: params[:description])
    # Success response: Render the updated project proposal as JSON
    project_proposal.to_json
  else
    # Error response: Render the error message as JSON
    { error: project_proposal.errors.full_messages }.to_json
  end
end

# Route to delete a specific project proposal
delete '/project_proposals/:id' do
  begin
    project_proposal = ProjectProposal.find(params[:id])
    project_proposal.destroy
    # Success response: Render a confirmation message as JSON
    { message: 'Project proposal deleted successfully.' }.to_json
  rescue ActiveRecord::InvalidForeignKey => e
    { error: 'Cannot delete the project proposal because it has associated records in another table.' }.to_json
  end
end


# Notes Routes
# Route to create a note for a specific project proposal
post '/project_proposals/:id/notes' do
  project_proposal = ProjectProposal.find(params[:id])
  note = project_proposal.notes.build(message: params[:message], designer_id: params[:designer_id])
  if note.save
    # Success response: Render the created note as JSON
    { message: 'Project note added successfully.' }.to_json
  else
    # Error response: Render the error message as JSON
    { error: note.errors.full_messages }.to_json
  end
end

# Route to view all notes for a project proposal
get '/project_proposals/:project_proposal_id/notes' do
  project_proposal = ProjectProposal.find(params[:project_proposal_id])
  # Success response: Render the note details as JSON
  notes = project_proposal.notes
  if notes.any?
    # Success response: Render the note details as JSON
    notes.to_json
  else
    # No notes found for the project proposal
    { message: 'No notes found for the project proposal.' }.to_json
  end
end

# Route to view a specific note for a project proposal
get '/project_proposals/:project_proposal_id/notes/:note_id' do
  project_proposal = nil
  note = nil

  begin
    project_proposal = ProjectProposal.find(params[:project_proposal_id])
    note = project_proposal.notes.find(params[:note_id])
  rescue ActiveRecord::RecordNotFound
    { message: "Cannot find proposal or note with the provided IDs." }.to_json
  end

  if project_proposal.nil?
    { message: "Cannot find proposal with id: #{params[:project_proposal_id]}" }.to_json
  elsif note.nil?
    { message: "Cannot find note with id: #{params[:note_id]}" }.to_json
  else
    note.to_json
  end
end


# Route to edit a specific note for a project proposal
patch '/project_proposals/:project_proposal_id/notes/:note_id' do
  project_proposal = nil
  note = nil
  begin
    project_proposal = ProjectProposal.find(params[:project_proposal_id])
    note = project_proposal.notes.find(params[:note_id])
  rescue ActiveRecord::RecordNotFound
    { message: "Cannot find proposal or note with the provided IDs." }.to_json
  end

  if project_proposal.nil?
    { message: "Cannot find proposal with id: #{params[:project_proposal_id]}" }.to_json
  elsif note.nil?
    new_note = project_proposal.notes.build(message: params[:message], designer_id: params[:designer_id])
    if new_note.save
      { message: "Cannot find note with id: #{params[:note_id]} but we successfuly created a new note"}.to_json
    else
      {message: "Note with id: #{params[:note_id]} not found and a new one could not be created"}.to_json    
    end
  else
    update = note.update(message: params[:message], designer_id: params[:designer_id])
    {message: "Note with id: #{params[:note_id]} updated"}.to_json    
  end
end


# Route to delete a specific note for a project proposal
delete '/project_proposals/:project_proposal_id/notes/:note_id' do
  project_proposal = nil
  note = nil
  begin
  project_proposal = ProjectProposal.find(params[:project_proposal_id])
  note = project_proposal.notes.find(params[:note_id])
  note.destroy
  # Check if the deletion was successful before returning the response
  if note.destroyed?
    # Success response: Render a confirmation message as JSON
    { message: 'Note deleted successfully.' }.to_json
  else
    { error: 'Failed to delete the note.' }.to_json
  end
rescue ActiveRecord::RecordNotFound
  { message: "Cannot find proposal or note with the provided IDs." }.to_json
rescue ActiveRecord::InvalidForeignKey => e
  { message: 'Cannot delete the note because it has associated records in another table.' }.to_json
end
end


# Error handling route for handling 404 (not found) errors
not_found do
  # Return a JSON response for 404 error
  status 404
  { error: 'Not Found' }.to_json
end

# Error handling route for handling 500 (internal server) errors
error 500 do
  # Return a JSON response for 500 error
  status 500
  { error: 'Internal Server Error' }.to_json
end

# Directory where uploaded files will be stored (using :file storage)
CarrierWave.configure do |config|
  config.root = File.join(__dir__, 'public')
end

# Route to handle avatar upload
post '/designers/:id/avatar' do
  designer = Designer.find(params[:id])
  designer.avatar = params[:avatar] # params[:avatar] should be the file uploaded in the request
  designer.save
  # Return success response or redirect to the designer's profile page
  { message: 'Avatar uploaded successfully.' }.to_json
end

# Route to retrieve the avatar URL for a designer
get '/designers/:id/avatar' do
  designer = Designer.find(params[:id])
  # Return the avatar URL as JSON
  { avatar_url: designer.avatar.url }.to_json
end

get '/' do
  { message: 'Good luck with your project!' }.to_json
end
end